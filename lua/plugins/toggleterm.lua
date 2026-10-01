-- Terminal at the bottom of the screen. Opens automatically on startup (see lua/config/autocmds.lua).
local size = 10

return {
    "akinsho/toggleterm.nvim",
    lazy = false, -- needed at startup for the <C-\> mapping
    keys = {
        { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
        open_mapping = [[<C-\>]],
        direction = "horizontal",
        size = size,
        persist_size = false,
        -- Always open in Normal mode; press i to start typing in the terminal.
        start_in_insert = false,
        persist_mode = false,
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)

        -- Snap the terminal back to its normal height when the Neovim window is resized
        -- (e.g. going fullscreen), whichever window has the cursor.
        vim.api.nvim_create_autocmd("VimResized", {
            group = vim.api.nvim_create_augroup("user_toggleterm_resize", { clear = true }),
            callback = function()
                for _, term in ipairs(require("toggleterm.terminal").get_all()) do
                    if term.direction == "horizontal" and term:is_open() then
                        vim.api.nvim_win_set_height(term.window, size)
                    end
                end
            end,
        })
    end,
}
