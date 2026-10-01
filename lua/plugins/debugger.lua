-- Debugger (DAP) for C/C++ (and Rust via rustaceanvim), with a UI that opens while debugging.
-- Needs an LLDB debug adapter: install lldb with your package manager (e.g. `sudo apt install lldb`)
-- or run :MasonInstall codelldb. See lua/util/lldb.lua for how it's found.

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
        "nvim-telescope/telescope-dap.nvim", -- :Telescope dap commands / configurations / list_breakpoints
    },
    keys = {
        { "<F5>", function() require("dap").continue() end, desc = "Debug: start / continue" },
        { "<F6>", function() require("dap").step_over() end, desc = "Debug: step over" },
        { "<F7>", function() require("dap").step_into() end, desc = "Debug: step into" },
        { "<F8>", function() require("dap").step_out() end, desc = "Debug: step out" },
        { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
        {
            "<leader>B",
            function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
            desc = "Debug: conditional breakpoint",
        },
        { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: open REPL" },
        { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: run last" },
        { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: stop" },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        -- Looked up when you start debugging, so installing lldb later doesn't need a restart.
        dap.adapters.lldb = function(callback)
            local lldb = require("util.lldb")
            local adapter = lldb.find_adapter()
            if not adapter then
                vim.notify("No LLDB debug adapter found. " .. lldb.install_hint, vim.log.levels.ERROR)
                return
            end
            callback(adapter)
        end

        dap.configurations.c = {
            {
                name = "Launch an executable",
                type = "lldb",
                request = "launch",
                program = function()
                    local path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    return path ~= "" and path or dap.ABORT
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false, -- run until the first breakpoint
                args = {},
            },
        }
        dap.configurations.cpp = dap.configurations.c
        -- Rust: rustaceanvim adds launch configurations for your cargo targets automatically.

        -- Plain Unicode instead of Nerd Font glyphs.
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
        vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
        vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "Visual" })

        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "→" },
            controls = {
                icons = {
                    pause = "⏸",
                    play = "▶",
                    step_into = "↓",
                    step_over = "↷",
                    step_out = "↑",
                    step_back = "↶",
                    run_last = "↻",
                    terminate = "■",
                    disconnect = "✕",
                },
            },
        })

        -- Open the debugger UI when a session starts and close it when the program ends.
        dap.listeners.before.attach.dapui_config = function() dapui.open() end
        dap.listeners.before.launch.dapui_config = function() dapui.open() end
        dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
        dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

        pcall(require("telescope").load_extension, "dap")
    end,
}
