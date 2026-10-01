local function augroup(name)
    return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- A directory given on the command line (`nvim .`). Read it now: nvim-tree renames its buffer
-- while Neovim starts up.
local start_dir
if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
    start_dir = vim.fn.fnamemodify(vim.fn.argv(0), ":p")
end

-- IDE-style layout on startup: file tree on the left, terminal along the bottom.
vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("startup_layout"),
    callback = function()
        if vim.o.diff then
            return
        end

        -- `nvim <directory>`: work in that directory. nvim-tree has already filled the whole
        -- window with it; close that (leaving an empty buffer) so it reopens as a side panel below.
        if start_dir then
            vim.cmd.cd(start_dir)
            require("nvim-tree.api").tree.close()
        end

        -- Leave "one-off" uses alone: git commit messages, man pages, etc.
        local buf = vim.api.nvim_get_current_buf()
        local is_git_message = vim.tbl_contains({ "gitcommit", "gitrebase" }, vim.bo[buf].filetype)
        if vim.bo[buf].buftype ~= "" or is_git_message then
            return
        end

        local opened_file = vim.api.nvim_buf_get_name(buf) ~= ""
        local editor_win = vim.api.nvim_get_current_win()

        require("nvim-tree.api").tree.open({ find_file = opened_file })
        vim.cmd("ToggleTerm")

        -- Put the cursor back in the file you opened, or in the tree if you didn't open one.
        if opened_file and vim.api.nvim_win_is_valid(editor_win) then
            vim.api.nvim_set_current_win(editor_win)
        else
            require("nvim-tree.api").tree.focus()
        end
    end,
})

-- Briefly highlight text after yanking (copying) it.
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.hl.on_yank()
    end,
})
