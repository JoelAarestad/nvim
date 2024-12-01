vim.g.mapleader = " "  -- Sets the Leader key to Space
vim.g.maplocalleader = " " -- Optional: Local leader key to Space

vim.api.nvim_set_keymap("n", "<Leader>w", ":w<CR>", { noremap = true, silent = true }) -- Save file
vim.api.nvim_set_keymap("n", "<Leader>q", ":qa<CR>", { noremap = true, silent = true }) -- Quit Neovim
vim.api.nvim_set_keymap("n", "<Leader>n", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>t", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true }) -- Exit terminal mode
