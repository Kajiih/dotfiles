if vim.g.vscode then
    -- VSCode extension
else
    -- ordinary Neovim
end

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- sync clipboard system
vim.opt.clipboard = 'unnamedplus'



-- open nvim config with leader + c in normal mod
vim.cmd('nmap <leader>c :e ~/.config/nvim/init.lua<cr>')

-- save with leader + s in normal mod
vim.cmd('nmap <leader>s :w<cr>')

-- motion keys (left, down, up, right) for "normal" and "visual" modes
-- vim.keymap.set({ 'n', 'v' }, 'j', 'h')
-- vim.keymap.set({ 'n', 'v' }, 'l', 'k')
-- vim.keymap.set({ 'n', 'v' }, ';', 'l')

-- repeat previous f, t, F or T movement
-- vim.keymap.set('n', '\'', ';')


-- add center after half page down/up
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })


-- paste without overwriting clipboard
vim.keymap.set('v', 'p', 'P')

-- redo
vim.keymap.set('n', 'U', '<C-r>')

-- clear search highlighting
vim.keymap.set('n', '<Esc>', ':nohlsearch<cr>')

-- skip folds (down, up)
vim.cmd('nmap j gj')
vim.cmd('nmap k gk')

-- search ignoring case
vim.opt.ignorecase = true

-- disable "ignorecase" option if the search pattern contains upper case characters
vim.opt.smartcase = true

