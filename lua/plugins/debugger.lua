local M = {}

function M.setup()
    local ok, dapui = pcall(require, "dapui")
    if not ok then
        vim.notify("dapui failed to load")
        return
    end

    local dap = require("dap")
    dap.adapters.lldb = {
        type = "executable",
        command = "/usr/lib/llvm-14/bin/lldb-vscode", -- Adjust this path
        name = "lldb"
    }

    dap.configurations.c = {
        {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = true,
            args = {}
        }
    }
    dap.configurations.cpp = dap.configurations.c

    -- DAP UI Setup
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    -- Debugger Keymaps
    vim.api.nvim_set_keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<F10>", ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<F11>", ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<F12>", ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>dr", ":lua require'dap'.repl.open()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>dl", ":lua require'dap'.run_last()<CR>", { noremap = true, silent = true })
end

return M

