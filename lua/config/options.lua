local opt = vim.opt

opt.termguicolors = true -- 24-bit color, so gruvbox looks right
opt.number = true
opt.relativenumber = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.cursorline = true
opt.signcolumn = "yes" -- always reserve space for diagnostics/breakpoint signs so text doesn't jump

-- Folding by syntax tree (functions, blocks, ...). Everything starts open;
-- use za (toggle), zc (close), zo (open), zM (close all), zR (open all).
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldtext = "" -- show a closed fold as its first line, with syntax highlighting

-- Share the system clipboard. Needs a clipboard tool: xclip or xsel (X11) or wl-clipboard (Wayland).
-- Scheduled because detecting the clipboard tool can slow down startup.
vim.schedule(function()
    opt.clipboard = "unnamedplus"
end)

-- nvim-tree replaces the built-in file browser (netrw), which has to be disabled before it loads.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
