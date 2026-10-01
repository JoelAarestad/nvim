-- Autocompletion popup (nvim-cmp) with LSP, snippet, path and buffer-word suggestions.
--   <C-n> / <C-p>  next / previous suggestion     <CR>     accept the selected suggestion
--   <C-Space>      open the menu                  <C-e>    close the menu
--   <C-f> / <C-b>  scroll the documentation       <C-l> / <C-h>  jump to next / previous snippet field
-- <Tab> is left to Copilot (accept suggestion).
return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            -- Optional regex support that some snippets use; needs `make` and a C compiler.
            build = vim.fn.executable("make") == 1 and "make install_jsregexp" or nil,
            dependencies = { "rafamadriz/friendly-snippets" }, -- ready-made snippets for many languages
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                -- Only accept an item you picked, so Enter still makes a new line otherwise.
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<C-l>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-h>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            }, {
                { name = "buffer" },
            }),
        })

        -- Completion when searching with / or ?
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } },
        })

        -- Completion for : commands
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
            matching = { disallow_symbol_nonprefix_matching = false },
        })
    end,
}
