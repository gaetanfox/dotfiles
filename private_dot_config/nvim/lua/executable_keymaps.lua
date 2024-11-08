-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('n', '<leader>tt', ':ToggleTerm<cr>', { desc = '[T]oggle [T]erminal' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
vim.keymap.set('t', 'jk', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])

-- Remap jj or jk to escape insert mode
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window Splitting
vim.keymap.set('n', '<leader>wv', ':vsplit<cr>', { desc = '[W]indow [V]ertical Split' })
vim.keymap.set('n', '<leader>wh', ':split<cr>', { desc = '[W]indow [H]orizontal Split' })

-- Window Save & Quit
vim.keymap.set('n', '<leader>wq', ':q<cr>', { desc = '[W]indow [Q]uit' })
vim.keymap.set('n', '<leader>ww', ':w<cr>', { desc = '[W]indow [W]rite' })
vim.keymap.set('n', '<leader>wc', ':bd<cr>', { desc = '[W]indow [C]lose' })
vim.keymap.set('n', '<leader>wn', ':bnext<cr>', { desc = '[W]indow [N]ext' })
vim.keymap.set('n', '<leader>wp', ':bprev<cr>', { desc = '[W]indow [P]rev' })

-- toggle undo tree
vim.keymap.set('n', '<leader>tu', ':UndotreeToggle<cr>', { desc = '[T]oggle [U]ndotree' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
--  TODO: figure out other helpful autocommands

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Define a Lua function to remove comments
local function remove_python_comments()
  -- Remove single-line comments
  vim.cmd [[%s/^\s*#.*//g]]
  -- Remove multi-line comments with '''
  vim.cmd [[silent! %s/\v(''')[\s\S]+%1//g]]
  -- Remove multi-line comments with """
  vim.cmd [[silent! %s/\v(""")[\s\S]+%1//g]]
end

-- Map the function to a key combination in normal mode
vim.api.nvim_set_keymap('n', '<leader>cs', '<cmd>lua remove_python_comments()<CR>', { noremap = true, silent = true })
-- vim: ts=2 sts=2 sw=2 et
