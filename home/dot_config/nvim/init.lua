-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.vscode then
  -- VSCode Neovim
  vim.opt.spell = false -- Disable spell checking
  vim.opt.spelllang = {} -- Clear spell check languages
else
  -- Ordinary Neovim
end

-- sync clipboard system
vim.opt.clipboard = "unnamedplus"

-- save with leader + s in normal mod
vim.cmd("nmap <leader>s :w<cr>")

-- redo
vim.keymap.set("n", "U", "<C-r>")

-- paste without overriting clipboard
-- vim.keymap.set('v', 'p', 'P')

-- add center after half page down/up
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
