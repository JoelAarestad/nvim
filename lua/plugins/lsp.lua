-- Language servers (LSP): diagnostics, go-to-definition, rename, smart completion, ...
--   C/C++: clangd, installed automatically through Mason.
--   Rust:  rust-analyzer, run by rustaceanvim. Install it with `rustup component add rust-analyzer`.
-- More languages: install a server with :Mason (or :LspInstall <name>). Servers installed
-- through Mason start automatically.
return {
    {
        "mason-org/mason.nvim",
        lazy = false,
        opts = {},
    },
    {
        "neovim/nvim-lspconfig", -- ready-made server configs, used by vim.lsp.enable()
        lazy = false,
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Tell every server about the extra completion features nvim-cmp supports.
            vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

            require("mason-lspconfig").setup({
                ensure_installed = { "clangd" },
                -- rustaceanvim starts rust-analyzer itself; enabling it here too would run it twice.
                automatic_enable = { exclude = { "rust_analyzer" } },
            })
            -- Also covers a clangd installed by your system package manager instead of Mason.
            vim.lsp.enable("clangd")

            vim.diagnostic.config({
                virtual_text = true, -- show errors at the end of the line (off by default since 0.11)
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
            })

            -- Neovim already maps K (hover), grn (rename), gra (code action), grr (references),
            -- [d / ]d (previous/next diagnostic). These add a few common extras.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
                callback = function(args)
                    local function map(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
                    end
                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format file")
                    map("<leader>e", vim.diagnostic.open_float, "Show diagnostics for this line")
                end,
            })
        end,
    },
    {
        -- Rust support (successor of the archived rust-tools.nvim).
        "mrcjkb/rustaceanvim",
        -- v9 needs Neovim 0.12; v8 is the last release that supports 0.11.
        version = vim.fn.has("nvim-0.12") == 1 and "^9" or "^8",
        lazy = false, -- it already only loads for Rust files
        init = function()
            vim.g.rustaceanvim = {
                -- Debug with the same LLDB adapter as C/C++ (rustaceanvim's own lookup misses
                -- versioned installs like Ubuntu's lldb-dap-18).
                dap = {
                    adapter = function()
                        return require("util.lldb").find_adapter() or false
                    end,
                },
            }
        end,
    },
}
