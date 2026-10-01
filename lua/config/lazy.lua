-- lazy.nvim plugin manager: https://lazy.folke.io
-- It installs itself on first start, then installs every plugin listed in lua/plugins/.
-- Open its window with :Lazy (U = update all, S = sync, X = clean, ? = help).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- The lockfile pins every plugin to a known-good commit; commit it after `:Lazy update`.
-- Neovim 0.11 needs older releases of a few plugins (see plugins/treesitter.lua and
-- plugins/lsp.lua), so it gets a lockfile of its own.
local lockfile = vim.fn.has("nvim-0.12") == 1 and "lazy-lock.json" or "lazy-lock.nvim-0.11.json"

require("lazy").setup({
    spec = { { import = "plugins" } },
    lockfile = vim.fn.stdpath("config") .. "/" .. lockfile,
    install = { colorscheme = { "gruvbox" } },
    change_detection = { notify = false },
    rocks = { enabled = false }, -- no plugin here needs luarocks
    ui = {
        -- Emoji instead of Nerd Font icons, like the rest of this config.
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})
