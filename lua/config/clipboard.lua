-- Copy and paste between Neovim and other programs (browser, Discord, ...).
--
--   Mouse:  select text, then right-click → Copy / Cut / Paste
--   Keys:   Ctrl-C copy, Ctrl-X cut, Ctrl-V paste (in every mode, including the terminal pane)
--           Ctrl-Q starts a block selection (what Ctrl-V does in plain Vim)
--   Vim:    y, d and p use the system clipboard too
--
-- Neovim reaches the system clipboard through a helper program:
--   Wayland (KDE, GNOME, Hyprland, Sway, ...):  wl-clipboard
--   X11 (i3, bspwm, Xfce, ...):                 xclip
-- If the one for your session is missing, you get a warning at startup.
local M = {}

-- Paste the system clipboard like the terminal's own paste (Ctrl+Shift+V) does: at the cursor,
-- over a selection, on the command line, or into the terminal pane.
function M.paste()
    local reg = vim.fn.getreginfo("+")
    local lines = reg.regcontents or {}
    if #lines == 0 then
        return
    end
    if reg.regtype == "V" then
        table.insert(lines, "") -- whole lines were copied: keep the final line break
    end
    vim.paste(lines, -1)
end

-- The clipboard program this session needs but doesn't have, if any.
local function missing_program()
    if (vim.env.WAYLAND_DISPLAY or "") ~= "" then
        if vim.fn.executable("wl-copy") == 0 or vim.fn.executable("wl-paste") == 0 then
            return "wl-clipboard" -- xclip only half works on Wayland
        end
    elseif (vim.env.DISPLAY or "") ~= "" then
        if vim.fn.executable("xclip") == 0 and vim.fn.executable("xsel") == 0 then
            return "xclip"
        end
    end
end

-- Without any clipboard program, copy through the terminal itself (OSC 52: kitty, foot,
-- alacritty, wezterm, konsole, ...). Terminals rarely let programs read the clipboard back, so
-- pasting gives the last text copied in Neovim; paste other programs' text with Ctrl+Shift+V.
local function copy_through_terminal()
    local osc52 = require("vim.ui.clipboard.osc52")
    local last = { {}, "v" }
    local function copy(reg)
        local send = osc52.copy(reg)
        return function(lines, regtype)
            last = { lines, regtype }
            send(lines)
        end
    end
    local function paste()
        return last
    end
    vim.g.clipboard = {
        name = "OSC 52",
        copy = { ["+"] = copy("+"), ["*"] = copy("*") },
        paste = { ["+"] = paste, ["*"] = paste },
    }
    -- Make Neovim pick up the new g:clipboard.
    vim.g.loaded_clipboard_provider = nil
    vim.cmd("runtime autoload/provider/clipboard.vim")
end

-- Scheduled because finding the clipboard program can slow down startup.
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
    if #vim.api.nvim_list_uis() == 0 then
        return -- headless (scripts): no terminal to copy through, nobody to warn
    end
    if vim.fn["provider#clipboard#Executable"]() == "" then
        copy_through_terminal()
    end

    local program = missing_program()
    if program then
        local install = vim.fn.executable("pacman") == 1 and "sudo pacman -S " .. program or "install it"
        vim.notify(("Copy/paste with other apps needs %s: %s"):format(program, install), vim.log.levels.WARN)
    end
end)

local map = vim.keymap.set
map("x", "<C-c>", '"+y', { desc = "Copy" })
map("x", "<C-x>", '"+d', { desc = "Cut" })
map({ "n", "x", "i", "c", "t" }, "<C-v>", M.paste, { desc = "Paste" })
map({ "n", "x" }, "<C-q>", "<C-v>", { desc = "Block selection" })

-- Right-click → Paste: same as Ctrl-V, so it also works in the terminal pane.
vim.cmd([[anoremenu PopUp.Paste <Cmd>lua require("config.clipboard").paste()<CR>]])

return M
