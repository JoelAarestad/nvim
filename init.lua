-- Neovim config entry point. See README.md for install steps and a keymap cheat sheet.
--
--   lua/config/options.lua   editor settings
--   lua/config/keymaps.lua   general keymaps (plugin keymaps live next to each plugin)
--   lua/config/clipboard.lua copy/paste with other programs (Ctrl-C/X/V, right-click menu)
--   lua/config/autocmds.lua  startup layout (file tree + terminal) and other autocommands
--   lua/config/lazy.lua      plugin manager (lazy.nvim)
--   lua/plugins/*.lua        one file per plugin / feature

if vim.fn.has("nvim-0.11") == 0 then
    local v = vim.version()
    local msg = ("This config needs Neovim 0.11 or newer, but this is %d.%d.%d.\n"):format(v.major, v.minor, v.patch)
    vim.api.nvim_echo({
        { msg, "ErrorMsg" },
        { "Upgrade Neovim (see README.md), then start it again.", "WarningMsg" },
    }, true, {})
    return
end

-- The leader key must be set before plugins load so their keymaps use it.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.clipboard")
require("config.autocmds")
require("config.lazy")
