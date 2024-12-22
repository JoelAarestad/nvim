-- Packer Bootstrapping
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Auto-reload Neovim when updating plugins
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]])

-- Packer Plugins
require("packer").startup(function(use)
    use("wbthomason/packer.nvim") -- Package manager

    -- Theme
    use("morhetz/gruvbox") -- Gruvbox theme

    -- File Explorer
    use {
        "nvim-tree/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" }
    }

    -- Terminal Toggle
    use("akinsho/toggleterm.nvim")

    -- LSP and Autocompletion
    use("neovim/nvim-lspconfig") -- LSP Config
    use("williamboman/mason.nvim") -- LSP Installer
    use("williamboman/mason-lspconfig.nvim")
    use("hrsh7th/nvim-cmp") -- Completion Framework
    use("hrsh7th/cmp-nvim-lsp") -- LSP Completion Source
    use("hrsh7th/cmp-buffer") -- Buffer Completion
    use("hrsh7th/cmp-path") -- Path Completion
    use("hrsh7th/cmp-cmdline") -- Command-line Completion
    use("L3MON4D3/LuaSnip") -- Snippets
    use("saadparwaiz1/cmp_luasnip") -- Snippet Completion

    -- Treesitter for Syntax Highlighting
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            pcall(vim.cmd, "TSUpdate")
        end
    }

    -- Rust Tools
    use("simrat39/rust-tools.nvim")

    -- Debugger and Debugger UI
    use {
        "mfussenegger/nvim-dap",
        requires = {
            "rcarriga/nvim-dap-ui",
            "nvim-telescope/telescope-dap.nvim", -- Optional: for Telescope integration
            "nvim-neotest/nvim-nio" -- Required for nvim-dap-ui
        }
    }

    -- Other Utilities
    use("nvim-lualine/lualine.nvim") -- Statusline
    use("nvim-telescope/telescope.nvim") -- Fuzzy Finder
    use("nvim-lua/plenary.nvim") -- Dependency for Telescope
    use("github/copilot.vim")

    if packer_bootstrap then
        require("packer").sync()
    end
end)
-- Settings
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = true

-- Keymaps
require("keymaps")

-- Open NvimTree and ToggleTerm on startup
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Open NvimTree
        require("nvim-tree.api").tree.open()
        -- Open ToggleTerm without entering terminal mode
        vim.cmd("ToggleTerm")
        vim.cmd("wincmd p") -- Switch back to the previous window (normal mode)
    end
})

-- Prevent entering terminal mode on toggling terminal
require("toggleterm").setup {
    open_mapping = [[<C-\>]],
    direction = "horizontal",
    size = 10,
    persist_size = false,
    on_open = function(term)
        vim.cmd("stopinsert") -- Ensure terminal starts in normal mode
    end
}
-- Nvim Tree Setup
require("nvim-tree").setup()


vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
        -- For horizontal terminals, reset the size to 10
        local ok, toggleterm = pcall(require, "toggleterm.terminal")
        if ok then
            for _, term in pairs(toggleterm.get_all()) do
                if term.direction == "horizontal" then
                    term:resize(10)
                end
            end
        end
    end
})

-- LSP Setup
require("mason").setup()
require("mason-lspconfig").setup()
require("lspconfig").clangd.setup{} -- C/C++ LSP
require("rust-tools").setup{} -- Rust LSP
    
-- Treesitter Setup
require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "cpp", "rust", "lua", "python" },
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
    },
    indent = {
        enable = true,
    }
}

-- Use Treesitter for folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- Start with folds closed

-- Statusline
require("lualine").setup()

-- Load plugins from lua/plugins
require("plugins.debugger").setup()

-- Gruvbox Theme
vim.cmd("colorscheme gruvbox")

