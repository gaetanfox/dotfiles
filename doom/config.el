;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Gaetan Fox"
      user-mail-address "me@gaetanfox.io")

;; remove top frame bar in emacs
(add-to-list 'default-frame-alist '(undecorated . t))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tokyo-night)

(set-frame-font "MesloLGS Nerd Font Mono 14")


;; Send files to trash instead of fully deleting
(setq delete-by-moving-to-trash t)
;; Save automatically
(setq auto-save-default t)


;; Performance optimizations
(setq gc-cons-threshold (* 256 1024 1024))
(setq read-process-output-max (* 4 1024 1024))
(setq comp-deferred-compilation t)
(setq comp-async-jobs-number 8)

;; Garbage collector optimization
(setq gcmh-idle-delay 5)
(setq gcmh-high-cons-threshold (* 1024 1024 1024))

;; Version control optimization
(setq vc-handled-backends '(Git))

;; Fix x11 issues
(setq x-no-window-manager t)
(setq frame-inhibit-implied-resize t)
(setq focus-follows-mouse nil)


;; Speed of which-key popup
(setq which-key-idle-delay 0.2)

;; Completion mechanisms
(setq completing-read-function #'completing-read-default)
(setq read-file-name-function #'read-file-name-default)
;; Makes path completion more like find-file everywhere
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)
;; Use the familiar C-x C-f interface for directory completion
(map! :map minibuffer-mode-map
      :when (featurep! :completion vertico)
      "C-x C-f" #'find-file)

;; Save minibuffer history - enables command history in M-x
(use-package! savehist
  :config
  (setq savehist-file (concat doom-cache-dir "savehist")
        savehist-save-minibuffer-history t
        history-length 1000
        history-delete-duplicates t
        savehist-additional-variables '(search-ring
                                        regexp-search-ring
                                        extended-command-history))
  (savehist-mode 1))

(after! vertico
  ;; Add file preview
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
  (define-key vertico-map (kbd "M-DEL") #'vertico-directory-delete-word)
  ;; Make vertico use a more minimal display
  (setq vertico-count 17
        vertico-cycle t
        vertico-resize t)
  ;; Enable alternative filter methods
  (setq vertico-sort-function #'vertico-sort-history-alpha)
  ;; Quick actions keybindings
  (define-key vertico-map (kbd "C-j") #'vertico-next)
  (define-key vertico-map (kbd "C-k") #'vertico-previous)
  (define-key vertico-map (kbd "M-RET") #'vertico-exit-input)

  ;; History navigation
  (define-key vertico-map (kbd "M-p") #'vertico-previous-history)
  (define-key vertico-map (kbd "M-n") #'vertico-next-history)
  (define-key vertico-map (kbd "C-r") #'consult-history)

  ;; Configure orderless for better filtering
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion orderless))))

  ;; Customize orderless behavior
  (setq orderless-component-separator #'orderless-escapable-split-on-space
        orderless-matching-styles '(orderless-literal
                                    orderless-prefixes
                                    orderless-initialism
                                    orderless-regexp)))

;; Quick command repetition
(use-package! vertico-repeat
  :after vertico
  :config
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  (map! :leader
        (:prefix "r"
         :desc "Repeat completion" "v" #'vertico-repeat)))
;; Configure consult for better previews
(after! consult
  (setq consult-preview-key "M-."
        consult-ripgrep-args "rg --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip"
        consult-narrow-key "<"
        consult-line-numbers-widen t
        consult-async-min-input 2
        consult-async-refresh-delay 0.15
        consult-async-input-throttle 0.2
        consult-async-input-debounce 0.1)

  ;; More useful previews for different commands
  (consult-customize
   consult-theme consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   :preview-key '(:debounce 0.4 any)))

;; Enhanced directory navigation
(use-package! consult-dir
  :bind
  (("C-x C-d" . consult-dir)
   :map vertico-map
   ("C-x C-d" . consult-dir)
   ("C-x C-j" . consult-dir-jump-file)))

;; Add additional useful shortcuts
(map! :leader
      (:prefix "s"
       :desc "Command history" "h" #'consult-history
       :desc "Recent directories" "d" #'consult-dir))

;; COMPANY
(after! company
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-show-quick-access t
        company-tooltip-limit 20
        company-tooltip-align-annotations t)

  ;; Make company-files a higher priority backend
  (setq company-backends (cons 'company-files (delete 'company-files company-backends)))

  ;; Better file path completion settings
  (setq company-files-exclusions nil)
  (setq company-files-chop-trailing-slash t)

  ;; Enable completion at point for file paths
  (defun my/enable-path-completion ()
    "Enable file path completion using company."
    (setq-local company-backends
                (cons 'company-files company-backends)))

  ;; Enable for all major modes
  (add-hook 'after-change-major-mode-hook #'my/enable-path-completion)

  ;; Custom file path trigger
  (defun my/looks-like-path-p (input)
    "Check if INPUT looks like a file path."
    (or (string-match-p "^/" input)         ;; Absolute path
        (string-match-p "^~/" input)        ;; Home directory
        (string-match-p "^\\.\\{1,2\\}/" input))) ;; Relative path

  (defun my/company-path-trigger (command &optional arg &rest ignored)
    "Company backend that triggers file completion for path-like input."
    (interactive (list 'interactive))
    (cl-case command
      (interactive (company-begin-backend 'company-files))
      (prefix (when (my/looks-like-path-p (or (company-grab-line "\\([^ ]*\\)" 1) ""))
                (company-files 'prefix)))
      (t (apply 'company-files command arg ignored))))

  ;; Add the custom path trigger to backends
  (add-to-list 'company-backends 'my/company-path-trigger))

;; MODELINE
(setq doom-modeline-icon t)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-lsp-icon t)
(setq doom-modeline-major-mode-color-icon t)

;; Blink cursor
(blink-cursor-mode 1)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Line wrapping
(global-visual-line-mode t)


(after! evil
  (setq evil-escape-key-sequence "kj")
  (setq evild-escape-delay 0.2))
                                        ; Don't move cursor back when exiting insert mode
(setq evil-move-cursor-back nil)
;; granular undo with evil mode
(setq evil-want-fine-undo t)
;; Enable paste from system clipboard with C-v in insert mode
(evil-define-key 'insert global-map (kbd "C-v") 'clipboard-yank)



;; Vterm adjustemts
(setq vterm-environment '("TERM=xterm-256color"))
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
;; (custom-set-faces!
;; '(vterm :family "Geistmono Nerd Font"))

;; open vterm in dired location
(after! vterm
  (setq vterm-buffer-name-string "vterm %s")

  ;; Modify the default vterm opening behavior
  (defadvice! +vterm-use-current-directory-a (fn &rest args)
    "Make vterm open in the directory of the current buffer."
    :around #'vterm
    (let ((default-directory (or (and (buffer-file-name)
                                      (file-name-directory (buffer-file-name)))
                                 (and (eq major-mode 'dired-mode)
                                      (dired-current-directory))
                                 default-directory)))
      (apply fn args)))

  ;; Also modify Doom's specific vterm functions
  (defadvice! +vterm-use-current-directory-b (fn &rest args)
    "Make Doom's vterm commands open in the directory of the current buffer."
    :around #'+vterm/here
    (let ((default-directory (or (and (buffer-file-name)
                                      (file-name-directory (buffer-file-name)))
                                 (and (eq major-mode 'dired-mode)
                                      (dired-current-directory))
                                 default-directory)))
      (apply fn args))))

(defun open-vterm-in-current-context ()
  "Open vterm in the context of the current buffer/window."
  (interactive)
  (when-let ((buf (current-buffer)))
    (with-current-buffer buf
      (call-interactively #'+vterm/here))))




;; Emmet remap
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(map! :map emmet-mode-keymap
      :n "<C-return>" #'emmet-expand-line)
(setq emmet-expand-jsx-className? t) ;; default nil



;; LSP Performance optimizations and settings
(after! lsp-mode
  (setq lsp-idle-delay 0.5
        lsp-log-io nil
        lsp-completion-provider :capf
        lsp-enable-file-watchers nil
        lsp-enable-folding nil
        lsp-enable-text-document-color nil
        lsp-enable-on-type-formatting nil
        lsp-enable-snippet nil
        lsp-enable-symbol-highlighting nil
        lsp-enable-links nil

        ;; Go-specific settings
        lsp-go-hover-kind "Synopsis"
        lsp-go-analyses '((fieldalignment . t)
                          (nilness . t)
                          (unusedwrite . t)
                          (unusedparams . t))

        ;; Register custom gopls settings
        lsp-gopls-completeUnimported t
        lsp-gopls-staticcheck t
        lsp-gopls-analyses '((unusedparams . t)
                             (unusedwrite . t))))

;; LSP UI settings for better performance
(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-max-height 8
        lsp-ui-doc-max-width 72
        lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-delay 0.5
        lsp-ui-sideline-enable nil
        lsp-ui-peek-enable t))




;; Enable Treesitter for Go in org
(after! tree-sitter
  (require 'tree-sitter-langs)
  (add-to-list 'tree-sitter-major-mode-language-alist '(org-mode . go)))




;; ;; Configure prettier
;; (use-package! prettier-js
;;   :config
;;   (setq prettier-js-args
;;         '("--parser" "svelte"
;;           "--tab-width" "2"
;;           "--use-tabs" "true")))




;; Tailwind CSS
(use-package! lsp-tailwindcss)



;; Treemacs
(require 'treemacs-all-the-icons)
(setq doom-themes-treemacs-theme "all-the-icons")



(defun my/magit-stage-commit-push ()
  "Stage all, commit with quick message, and push with no questions"
  (interactive)
  (magit-stage-modified)
  (let ((msg (read-string "Commit message: ")))
    (magit-commit-create (list "-m" msg))
    (magit-run-git "push" "origin" (magit-get-current-branch))))



(after! dap-mode
  (require 'dap-dlv-go)

  ;; Remove problematic hooks
  (remove-hook 'dap-stopped-hook 'dap-ui-repl-toggle)
  (remove-hook 'dap-session-created-hook 'dap-ui-mode))




;;ORG MODE
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org")

(use-package org
  :ensure nil
  :custom (org-modules '(org-habit)))

(after! org
  (map! :map org-mode-map
        :n "<M-left>" #'org-do-promote
        :n "<M-right>" #'org-do-demote)
  )

;; Auto-clock in when state changes to STRT
(defun my/org-clock-in-if-starting ()
  "Clock in when the task state changes to STRT"
  (when (and (string= org-state "STRT")
             (not (org-clock-is-active)))
    (org-clock-in)))

;; Auto-clock out when leaving STRT state
(defun my/org-clock-out-if-not-starting ()
  "Clock out when leaving STRT state"
  (when (and (org-clock-is-active)
             (not (string= org-state "STRT")))
    (org-clock-out)))

;; Add these functions to org-after-todo-state-change-hook
(add-hook 'org-after-todo-state-change-hook 'my/org-clock-in-if-starting)
(add-hook 'org-after-todo-state-change-hook 'my/org-clock-out-if-not-starting)

;; Show habits in agenda
(setq org-habit-show-all-today t)
(setq org-habit-graph-column 1)
(add-hook 'org-agenda-mode-hook
          (lambda ()
            (visual-line-mode -1)
            (setq truncate-lines 1)))

(after! org
  (use-package! org-fancy-priorities
    :hook
    (org-mode . org-fancy-priorities-mode)
    :config
    (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕"))))

;; Prevent clock from stopping when marking subtasks as done
(setq org-clock-out-when-done nil)



;; Org-auto-tangle
(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))



;; Org Agenda
;; Set days viewed to 3, set start day to today, create seperator, and Dashboard view
(setq org-agenda-remove-tags t)
(setq org-agenda-block-separator 32)
(setq org-agenda-custom-commands
      '(("d" "Dashboard"
         (
          (tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "\n HIGHEST PRIORITY")
                 (org-agenda-prefix-format "   %i %?-2 t%s")
                 )
                )
          (agenda ""
                  (
                   (org-agenda-start-day "+0d")
                   (org-agenda-span 1)
                   (org-agenda-time)
                   (org-agenda-remove-tags t)
                   (org-agenda-todo-keyword-format "")
                   (org-agenda-scheduled-leaders '("" ""))
                   (org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈┈┈ NOW")
                   (org-agenda-overriding-header "\n TODAY'S SCHEDULE")
                   (org-agenda-prefix-format "   %i %?-2 t%s")
                   )
                  )
          (tags-todo  "-STYLE=\"habit\""
                      (
                       (org-agenda-overriding-header "\n ALL TODO")
                       (org-agenda-sorting-strategy '(priority-down))
                       (org-agenda-remove-tags t)
                       (org-agenda-prefix-format "   %i %?-2 t%s")
                       )
                      )))))

;; Remove Scheduled tag
(setq org-agenda-scheduled-leaders '("" ""))
;; Remove holidays from agenda
(setq org-agenda-include-diary nil)



;; Capture templates
(setq org-capture-templates
      '(("t" "Todo" entry
         (file+headline "~/org/inbox.org" "Inbox")
         "* TODO %^{Task}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?")

        ("e" "Event" entry
         (file+headline "~/org/calendar.org" "Events")
         "* %^{Event}\n%^{SCHEDULED}T\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:CONTACT: %(org-capture-ref-link \"~/org/contacts.org\")\n:END:\n%?")

        ("d" "Deadline" entry
         (file+headline "~/org/calendar.org" "Deadlines")
         "* TODO %^{Task}\nDEADLINE: %^{Deadline}T\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?")

        ("p" "Project" entry
         (file+headline "~/org/projects.org" "Projects")
         "* PROJ %^{Project name}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n** TODO %?")

        ("i" "Idea" entry
         (file+headline "~/org/ideas.org" "Ideas")
         "** IDEA %^{Idea}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?")

        ("b" "Bookmark" entry
         (file+headline "~/org/bookmarks.org" "Inbox")
         "** [[%^{URL}][%^{Title}]]\n:PROPERTIES:\n:CREATED: %U\n:TAGS: %(org-capture-bookmark-tags)\n:END:\n\n"
         :empty-lines 0)

        ("c" "Contact" entry
         (file+headline "~/org/contacts.org" "Inbox")
         "* %^{Name}

:PROPERTIES:
:CREATED: %U
:CAPTURED: %a
:EMAIL: %^{Email}
:PHONE: %^{Phone}
:BIRTHDAY: %^{Birthday +1y}u
:LOCATION: %^{Address}
:LAST_CONTACTED: %U
:END:
\\ *** Communications
\\ *** Notes
%?")

        ("n" "Note" entry
         (file+headline "~/org/notes.org" "Inbox")
         "* [%<%Y-%m-%d %a>] %^{Title}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?"
         :prepend t)))

(defun org-capture-bookmark-tags ()
  "Get tags from existing bookmarks and prompt for tags with completion."
  (save-window-excursion
    (let ((tags-list '()))
      ;; Collect existing tags
      (with-current-buffer (find-file-noselect "~/org/bookmarks.org")
        (save-excursion
          (goto-char (point-min))
          (while (re-search-forward "^:TAGS:\\s-*\\(.+\\)$" nil t)
            (let ((tag-string (match-string 1)))
              (dolist (tag (split-string tag-string "[,;]" t "[[:space:]]"))
                (push (string-trim tag) tags-list))))))
      ;; Remove duplicates and sort
      (setq tags-list (sort (delete-dups tags-list) 'string<))
      ;; Prompt user with completion
      (let ((selected-tags (completing-read-multiple "Tags (comma-separated): " tags-list)))
        ;; Return as a comma-separated string
        (mapconcat 'identity selected-tags ", ")))))

;; Helper function to select and link a contact
(defun org-capture-ref-link (file)
  "Create a link to a contact in contacts.org"
  (let* ((headlines (org-map-entries
                     (lambda ()
                       (cons (org-get-heading t t t t)
                             (org-id-get-create)))
                     t
                     (list file)))
         (contact (completing-read "Contact: "
                                   (mapcar #'car headlines)))
         (id (cdr (assoc contact headlines))))
    (format "[[id:%s][%s]]" id contact)))

;; Set archive location to done.org under current date
;; (defun my/archive-done-task ()
;;   "Archive current task to done.org under today's date"
;;   (interactive)
;;   (let* ((date-header (format-time-string "%Y-%m-%d %A"))
;;          (archive-file (expand-file-name "~/org/done.org"))
;;          (location (format "%s::* %s" archive-file date-header)))
;;     ;; Only archive if not a habit
;;     (unless (org-is-habit-p)
;;       ;; Add COMPLETED property if it doesn't exist
;;       (org-set-property "COMPLETED" (format-time-string "[%Y-%m-%d %a %H:%M]"))
;;       ;; Set archive location and archive
;;       (setq org-archive-location location)
;;       (org-archive-subtree))))

;; Automatically archive when marked DONE, except for habits
;; (add-hook 'org-after-todo-state-change-hook
;;           (lambda ()
;;             (when (and (string= org-state "DONE")
;;                        (not (org-is-habit-p)))
;;               (my/archive-done-task))))

;; Optional key binding if you ever need to archive manually
(define-key org-mode-map (kbd "C-c C-x C-a") 'my/archive-done-task)



;;Org-Roam
;; Org-Roam Configuration with SQLite Built-in Connector
(use-package! org-roam
  :custom
  ;; Set your org-roam directory
  (org-roam-directory "~/org/roam")

  ;; Explicitly use the built-in SQLite connector
  (org-roam-database-connector 'sqlite-builtin)

  ;; Set an absolute path for the database file
  (org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))

  :config
  ;; Make sure the directory exists
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))

  ;; Add error handling for database operations
  (advice-add 'org-roam-db-query :around
              (lambda (fn &rest args)
                (condition-case err
                    (apply fn args)
                  (error
                   (message "Database error in org-roam: %S" err)
                   nil))))

  ;; Enable auto-sync mode to keep the database updated
  (org-roam-db-autosync-mode +1))

;; Org-Roam UI setup - only load after org-roam is properly initialized
(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; org-download customizations
(require 'org-download)
(setq-default org-download-screenshot-method "scrot -s %s")

;; Debugging function for SQLite issues
(defun debug-org-roam-db ()
  "Debug function to test org-roam database connection."
  (interactive)
  (message "Testing org-roam database...")
  (message "Directory exists: %s" (file-exists-p org-roam-directory))
  (message "Database path: %s" org-roam-db-location)
  (message "Database connector: %s" org-roam-database-connector)
  (condition-case err
      (progn
        (org-roam-db-sync)
        (message "Database synced successfully!"))
    (error (message "Database sync error: %S" err))))

                                        ; Keybinds for org mode
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-i") #'my/org-insert-image)
  (define-key org-mode-map (kbd "C-c e") #'org-set-effort)
  (define-key org-mode-map (kbd "C-c i") #'org-clock-in)
  (define-key org-mode-map (kbd "C-c o") #'org-clock-out))

;; Insert image into org from selection
(defun my/org-insert-image ()
  "Select and insert an image into org file."
  (interactive)
  (let ((selected-file (read-file-name "Select image: " "~/Pictures/" nil t)))
    (when selected-file
      (insert (format "[[file:%s]]\n" selected-file))
      (org-display-inline-images))))



(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((go . t)))

  (setq org-src-fontify-natively t
        org-src-preserve-indentation t
        org-src-tab-acts-natively t
        ;; Don't save source edits in temp files
        org-src-window-setup 'current-window))

;; Specifically for go-mode literate programming
(defun org-babel-edit-prep:go (babel-info)
  (when-let ((tangled-file (->> babel-info caddr (alist-get :tangle))))
    (let ((full-path (expand-file-name tangled-file)))
      ;; Don't actually create/modify the tangled file
      (setq-local buffer-file-name full-path)
      (lsp-deferred))))

;; Configure uv.el
(use-package! uv
  :defer t
  :init
  ;; Ensure TOML tree-sitter grammar is available
  (add-to-list 'treesit-language-source-alist
               '(toml "https://github.com/tree-sitter-grammars/tree-sitter-toml"))
  (unless (treesit-language-available-p 'toml)
    (treesit-install-language-grammar 'toml))
  :config
  ;; Optional: Set keybindings
  (map! :leader
        (:prefix ("p" . "project")
         :desc "UV Package Manager" "u" #'uv)))
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(after! flycheck
  ;; Disable flake8 and other slower checkers
  (setq-default flycheck-disabled-checkers 
                '(python-flake8 
                  python-pylint 
                  python-mypy)))

;; Optional: Configure LSP to use ruff-lsp if you have it
(after! lsp-mode
  (when (executable-find "ruff-lsp")
    (add-to-list 'lsp-language-id-configuration '(python-mode . "python"))
    (lsp-register-client
     (make-lsp-client :new-connection (lsp-stdio-connection "ruff-lsp")
                      :activation-fn (lsp-activate-on "python")
                      :server-id 'ruff-lsp))))

;; Custom keybindings for replacing words
(map! :leader
      (:prefix ("d" . "custom")
       :desc "Replace word on line" "r"
       (lambda ()
         (interactive)
         (let ((word (thing-at-point 'word t)))
           (when word
             (save-restriction
               (narrow-to-region (line-beginning-position) (line-end-position))
               (replace-string word (read-string (format "Replace '%s' with: " word)))))))

       :desc "Replace word in buffer" "R"
       (lambda ()
         (interactive)
         (let ((word (thing-at-point 'word t)))
           (when word
             (replace-string word (read-string (format "Replace '%s' with: " word))))))))
