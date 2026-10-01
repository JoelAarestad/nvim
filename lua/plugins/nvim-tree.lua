-- File explorer. Opens automatically on startup (see lua/config/autocmds.lua).
return {
    "nvim-tree/nvim-tree.lua",
    lazy = false, -- needed at startup to take over `nvim <directory>` from netrw
    keys = {
        { "<leader>n", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    opts = {
        renderer = {
            icons = {
                -- Plain emoji/Unicode instead of Nerd Font glyphs, so no special font is needed.
                glyphs = {
                    default = "📄",
                    symlink = "🔗",
                    bookmark = "🔖",
                    folder = {
                        arrow_closed = "▶",
                        arrow_open = "▼",
                        default = "📁",
                        open = "📂",
                        empty = "🗀",
                        empty_open = "🗁",
                        symlink = "🔗",
                        symlink_open = "🔗",
                    },
                    git = {
                        unmerged = "≠",
                        deleted = "✖",
                    },
                },
            },
        },
    },
}
