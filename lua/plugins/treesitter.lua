-- Treesitter: syntax highlighting, indentation and folding based on a real parser.
-- Add languages to this list (see :help nvim-treesitter for names), then restart Neovim.
local parsers = { "c", "cpp", "rust", "lua", "python" }

-- nvim-treesitter was rewritten for Neovim 0.12 (the `main` branch). The old `master` branch
-- is frozen and only works on Neovim 0.11, so pick the branch that matches this Neovim.
if vim.fn.has("nvim-0.12") == 1 then
    return {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local installed = require("nvim-treesitter").get_installed("parsers")
            local missing = vim.tbl_filter(function(lang)
                return not vim.list_contains(installed, lang)
            end, parsers)
            if #missing > 0 then
                if vim.fn.executable("tree-sitter") == 1 then
                    require("nvim-treesitter").install(missing)
                else
                    vim.notify(
                        "Can't install Treesitter parsers for: " .. table.concat(missing, ", ")
                            .. "\nInstall the tree-sitter CLI (see README.md), then restart Neovim.",
                        vim.log.levels.WARN
                    )
                end
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                    -- Highlighting (does nothing if no parser is installed for this language).
                    if not lang or not pcall(vim.treesitter.start, args.buf, lang) then
                        return
                    end
                    -- Indentation, for languages that have Treesitter indent rules.
                    local ok, indents = pcall(vim.treesitter.query.get, lang, "indents")
                    if ok and indents then
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    }
end

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = parsers,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = true },
    },
}
