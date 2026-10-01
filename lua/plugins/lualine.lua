-- Status line.
return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = {
        options = {
            theme = "gruvbox",
            -- No Nerd Font needed: plain separators, and text instead of icons.
            icons_enabled = false,
            component_separators = "|",
            section_separators = "",
        },
        extensions = { "nvim-tree", "toggleterm", "lazy", "mason", "nvim-dap-ui" },
    },
}
