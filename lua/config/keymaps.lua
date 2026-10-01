-- General keymaps. Plugin keymaps are defined with their plugin in lua/plugins/.
-- Leader is Space (set in init.lua).
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit Neovim" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
