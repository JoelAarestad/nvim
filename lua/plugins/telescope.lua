-- Fuzzy finder for files, text, buffers and help. Live grep needs ripgrep (`rg`) installed.
return {
    "nvim-telescope/telescope.nvim",
    version = "*", -- latest release
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search text in files" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find open buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Search help" },
    },
    opts = {},
}
