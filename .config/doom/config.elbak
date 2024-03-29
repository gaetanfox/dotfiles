;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Gaetan Fox"
      user-mail-address "me@gaetanfox.io")

;; MAC STUFF
(setq mac-command-modifier 'meta
      mac-option-modifier nil
      mac-control-modifier 'control
      )

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;

(setq doom-localleader-key ",")

;; COPY stuff
(map! :leader
      :desc "Paste stuff from clipboard"
        (:prefix ("v" . "Copy/Paste")
                :desc "Paste from other windows" "v" #'clipboard-yank
                :desc "Paste screenshot from clipboard" "s" #'org-download-clipboard
                :desc "Paste to other windows outside of emacs" "c" #'clipboard-kill-region))

;; ORG MODE HIDE CODE BLOCK
(map! :leader
      :desc "Show/Hide code block in org mode"
        (:prefix ("v" . "Show/Hide")
                :desc "Show/Hide code block in org mode" "h" #'org-fold-hide-block-toggle))


(setq doom-theme 'catppuccin)
(setq doom-font (font-spec :family "RobotoMono Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "RobotoMono Nerd Font" :size 15)
      doom-big-font (font-spec :family "RobotoMono Nerd Font" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq projectile-project-search-path '("~/dev" "~/org" "~/dev/zyte/playground"))


;; Global Auto Revert
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; CALENDAR
(defun dt/year-calendar (&optional year)
  (interactive)
  (require 'calendar)
  (let* (
      (current-year (number-to-string (nth 5 (decode-time (current-time)))))
      (month 0)
      (year (if year year (string-to-number (format-time-string "%Y" (current-time))))))
    (switch-to-buffer (get-buffer-create calendar-buffer))
    (when (not (eq major-mode 'calendar-mode))
      (calendar-mode))
    (setq displayed-month month)
    (setq displayed-year year)
    (setq buffer-read-only nil)
    (erase-buffer)
    ;; horizontal rows
    (dotimes (j 4)
      ;; vertical columns
      (dotimes (i 3)
        (calendar-generate-month
          (setq month (+ month 1))
          year
          ;; indentation / spacing between months
          (+ 5 (* 25 i))))
      (goto-char (point-max))
      (insert (make-string (- 10 (count-lines (point-min) (point-max))) ?\n))
      (widen)
      (goto-char (point-max))
      (narrow-to-region (point-max) (point-max)))
    (widen)
    (goto-char (point-min))
    (setq buffer-read-only t)))

(defun dt/scroll-year-calendar-forward (&optional arg event)
  "Scroll the yearly calendar by year in a forward direction."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     last-nonmenu-event))
  (unless arg (setq arg 0))
  (save-selected-window
    (if (setq event (event-start event)) (select-window (posn-window event)))
    (unless (zerop arg)
      (let* (
              (year (+ displayed-year arg)))
        (dt/year-calendar year)))
    (goto-char (point-min))
    (run-hooks 'calendar-move-hook)))

(defun dt/scroll-year-calendar-backward (&optional arg event)
  "Scroll the yearly calendar by year in a backward direction."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     last-nonmenu-event))
  (dt/scroll-year-calendar-forward (- (or arg 1)) event))

(map! :leader
      :desc "Scroll year calendar backward" "<left>" #'dt/scroll-year-calendar-backward
      :desc "Scroll year calendar forward" "<right>" #'dt/scroll-year-calendar-forward)

(defalias 'year-calendar 'dt/year-calendar)

;; EMOJIS
(use-package emojify
  :hook (after-init . global-emojify-mode))

;; EWW
(setq browse-url-browser-function 'eww-browse-url)
(map! :leader
      :desc "Search web for text between BEG/END"
      "s w" #'eww-search-words
      (:prefix ("e" . "evaluate/ERC/EWW")
       :desc "Eww web browser" "w" #'eww
       :desc "Eww reload page" "R" #'eww-reload))

;; INSERT DATE
(defun dt/insert-todays-date (prefix)
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%A, %B %d, %Y")
                 ((equal prefix '(4)) "%m-%d-%Y")
                 ((equal prefix '(16)) "%Y-%m-%d"))))
    (insert (format-time-string format))))

(require 'calendar)
(defun dt/insert-any-date (date)
  "Insert DATE using the current locale."
  (interactive (list (calendar-read-date)))
  (insert (calendar-date-string date)))

(map! :leader
      (:prefix ("i d" . "Insert date")
        :desc "Insert any date"    "a" #'dt/insert-any-date
        :desc "Insert todays date" "t" #'dt/insert-todays-date))

;; MARKDOWN
(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.7))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.2)))))

;; MODELINE
(setq doom-modeline-height 30     ;; sets modeline height
      doom-modeline-bar-width 5   ;; sets right bar width
      doom-modeline-persp-name t  ;; adds perspective name to modeline
      doom-modeline-persp-icon t) ;; adds folder icon next to persp name

;; MOUSE SUPPORT
(xterm-mouse-mode 1)

;; ORG  MODE
(after! org
  (setq org-agenda-files (directory-files-recursively "~/org/" "\\.org$"))
  (setq org-directory "~/org/"
        org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        org-todo-keywords
        '((sequence
           "TODO(t/!)"           ; A task that is ready to be tackled
           "PROG(p/!)"           ; A task that is in progress
           "WAIT(w/!)"           ; Something is holding up this task
           "|"                 ; The pipe necessary to separate "active" states and "inactive" states
           "DONE(d/!)"           ; Task has been completed
           "CANCELLED(c/!)" )))) ; Task has been cancelled

;; ORG AGENDA
(after! org
  (setq org-id-link-to-org-use-id t)
  (setq org-agenda-deadline-leaders
          '("" "" "%2d d. ago: ")
        org-deadline-warning-days 0
        org-agenda-span 7
        org-agenda-start-day "-0d"
        org-agenda-files '("~/org/agenda.org" "~org/*.org")
        org-agenda-skip-function-global
          '(org-agenda-skip-entry-if 'todo 'done)
        org-log-done 'time)
)

(setq
   ;; org-fancy-priorities-list '("[A]" "[B]" "[C]")
   ;; org-fancy-priorities-list '("❗" "[B]" "[C]")
   org-fancy-priorities-list '("🟥" "🟧" "🟨")
   org-priority-faces
   '((?A :foreground "#ff6c6b" :weight bold)
     (?B :foreground "#98be65" :weight bold)
     (?C :foreground "#c678dd" :weight bold))
   org-agenda-block-separator 8411)

;; (setq org-agenda-custom-commands
;;       '(("v" "A better agenda view"
;;          ((tags "PRIORITY=\"A\""
;;                 ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
;;                  (org-agenda-overriding-header "High-priority unfinished tasks:")))
;;           (tags "PRIORITY=\"B\""
;;                 ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
;;                  (org-agenda-overriding-header "Medium-priority unfinished tasks:")))
;;           (tags "PRIORITY=\"C\""
;;                 ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
;;           (tags "customtag"
;;                 ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
;;                  (org-agenda-overriding-header "Tasks marked with customtag:")))

;;           (agenda "")
;;           (alltodo "")))))))
  (setq org-agenda-deadline-leaders
          '("" "" "%2d d. ago: ")
        org-deadline-warning-days 0
        org-agenda-span 7
        org-agenda-start-day "-0d"
        org-agenda-skip-function-global
          '(org-agenda-skip-entry-if 'todo 'done)
        org-log-done 'time)

(defun my/update-org-agenda-files ()
  (setq org-agenda-files (directory-files-recursively "~/org/" "\\.org$")))

(add-hook 'org-agenda-mode-hook 'my/update-org-agenda-files)
;; ;; ORG JOURNAL
(setq org-journal-dir "~/org/journal/"
      org-journal-date-prefix "* "
      org-journal-time-prefix "** "
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org")

;; ORG ROAM
(after! org
  (setq org-roam-directory "~/org/"))

;; ORG APPEAR
(setq org-appear-trigger 'always
      org-hide-emphasis-markers t)

;; RAINBOW MODE
 (define-globalized-minor-mode global-rainbow-mode rainbow-mode
  (lambda ()
    (when (not (memq major-mode
                (list 'org-agenda-mode)))
     (rainbow-mode 1))))
(global-rainbow-mode 1 )

;; SPLITS
(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window" "b c" #'clone-indirect-buffer-other-window)

;; ORG CAPTURE
(after! org-capture
  (setq org-capture-templates
        '(("t" "todo" entry
           (file "~/org/todos.org")
           "* TODO %?")
          ("T" "todo today" entry
           (file "~/org/todos.org")
           "* TODO %?\nDEADLINE: %t")
          ("i" "inbox" entry
           (file "~/org/inbox.org")
           "* %?")
          ("v" "clip to inbox" entry
           (file "~/org/inbox.org")
           "* %x%?")
          )
        )
)

;; PYTHON CONFIG
(use-package python
  :config
  ;; Remove guess indent python message
  (setq python-indent-guess-indent-offset-verbose nil))

(use-package blacken
  :ensure t
  :defer t
  :custom
  (blacken-allow-py36 t)
  (blacken-skip-string-normalization t)
  :hook (python-mode-hook . blacken-mode))

(use-package eglot
  :ensure t
  :defer t
  :hook (python-mode . eglot-ensure))


(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1))

;; CSHARP
(setq omnisharp-server-executable-path "/opt/homebrew/bin/omnisharp")
(eval-after-load
  'company
  '(add-to-list 'company-backends #'company-omnisharp))

(defun my-csharp-mode-setup ()
  ;; (omnisharp-mode)
  (company-mode)
  (flycheck-mode)

  (setq indent-tabs-mode nil)
  (setq c-syntactic-indentation t)
  (c-set-style "ellemtel")
  (setq c-basic-offset 4)
  (setq truncate-lines t)
  (setq tab-width 4)
  (setq evil-shift-width 4)

  ;csharp-mode README.md recommends this too
  ;(electric-pair-mode 1)       ;; Emacs 24
  ;(electric-pair-local-mode 1) ;; Emacs 25

  (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
  (local-set-key (kbd "C-c C-c") 'recompile))

(add-hook 'csharp-mode-hook 'my-csharp-mode-setup t)

;; BEACON
(use-package beacon)
(beacon-mode 1)

;; TOC-ORG
(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

;; ORG-MODERN-MODE
(use-package org-modern
  :init
  (add-hook 'org-mode-hook 'org-modern-mode))

;; FOCUS
(use-package focus)

;; CATPUCCIN THEME
;; (use-package catppuccin-theme)

;; ALL  fTHE ICONS
(use-package all-the-icons
  :if (display-graphic-p))
(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode))))

;; ORG-AUTO-TANGLE
;; (use-package org-auto-tangle
;;   :defer t
;;   :hook (org-mode . org-auto-tangle-mode))
;; org download
(require 'org-download)
         (add-hook 'dired-mode-hook 'org-download-enable)
         (setq-default
          org-download-method 'directory
          org-download-image-dir "images"
          org-download-heading-lvl nil)
;;TESTS

(defun my/org-follow-link-split-right ()
  "Follow an Org mode link and display it in a split window to the left."
  (interactive)
  ;; Check if we're on a link and follow it.
  (if (org-in-regexp org-link-bracket-re 1)
      (let ((original-window (selected-window))
            (original-buffer (current-buffer)))
        (org-open-at-point)
        ;; If after opening the link we are still in the original window, it means the link did not open in a new buffer.
        (when (eq original-window (selected-window))
          ;; So we split the window to the right and then swap the window contents to simulate opening to the left.
          (let ((new-window (split-window-right)))
            ;; Open the link in the new window.
            (set-window-buffer new-window (current-buffer))
            (set-window-buffer original-window original-buffer)
            ;; Move focus to the new window on the left with the link's content.
            (select-window new-window)))
        (message "Followed the link."))
    (message "Not on an Org link!")))


(map! :leader
      (:prefix ("f o" . "Open in split R")
        :desc "Right Split" "r" #'my/org-follow-link-split-right))
(setq org-log-into-drawer t)
(setq org-archive-location "~/org/archive.org::")
(defun ndk/org-refile-candidates ()
     (directory-files "~/org" t ".*\\.org$"))
(add-to-list 'org-refile-targets '(ndk/org-refile-candidates :maxlevel . 3))
;; ;; GOLDEN RATIO
;; (require 'golden-ratio)
;; (golden-ratio-mode 1)
;; (define-advice select-window (:after (window &optional no-record) golden-ratio-resize-window)
;;     (golden-ratio)
;;     nil)

;; Always show workspaces in minibuffer
(after! persp-mode
  (defun display-workspaces-in-minibuffer ()
    (with-current-buffer " *Minibuf-0*"
      (erase-buffer)
      (insert (+workspace--tabline))))
  (run-with-idle-timer 1 t #'display-workspaces-in-minibuffer)
  (+workspace/display))
