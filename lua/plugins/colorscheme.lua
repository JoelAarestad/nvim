-- Gruvbox, via its maintained Lua port (same colors as morhetz/gruvbox, plus
-- Treesitter/LSP highlight groups).
return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000, -- load before everything else so other plugins pick up its colors
    opts = {
        italic = { strings = false },
    },
    config = function(_, opts)
        require("gruvbox").setup(opts)
        vim.cmd.colorscheme("gruvbox")
    end,
}
