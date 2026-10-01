-- Finds an LLDB debug adapter. Shared by C/C++ debugging (plugins/debugger.lua) and Rust
-- debugging (rustaceanvim, plugins/lsp.lua).
local M = {}

-- Returns an nvim-dap adapter for lldb-dap (named lldb-vscode before LLVM 18) or CodeLLDB,
-- or nil if none is installed.
function M.find_adapter()
    for _, name in ipairs({ "lldb-dap", "lldb-vscode" }) do
        if vim.fn.executable(name) == 1 then
            return { type = "executable", command = vim.fn.exepath(name), name = "lldb" }
        end
    end

    -- Distro packages often only install versioned names, e.g. /usr/bin/lldb-dap-18 or
    -- /usr/lib/llvm-14/bin/lldb-vscode. Use the newest one.
    local candidates = {}
    for _, pattern in ipairs({
        "/usr/bin/lldb-dap-*",
        "/usr/bin/lldb-vscode-*",
        "/usr/lib/llvm-*/bin/lldb-dap",
        "/usr/lib/llvm-*/bin/lldb-vscode",
        "/opt/homebrew/opt/llvm/bin/lldb-dap",
        "/usr/local/opt/llvm/bin/lldb-dap",
    }) do
        vim.list_extend(candidates, vim.fn.glob(pattern, false, true))
    end
    local function llvm_version(path)
        return tonumber(path:match("%-(%d+)$") or path:match("llvm%-(%d+)")) or 0
    end
    table.sort(candidates, function(a, b)
        return llvm_version(a) > llvm_version(b)
    end)
    for _, path in ipairs(candidates) do
        if vim.fn.executable(path) == 1 then
            return { type = "executable", command = path, name = "lldb" }
        end
    end

    if vim.fn.executable("codelldb") == 1 then -- e.g. from :MasonInstall codelldb
        return {
            type = "server",
            port = "${port}",
            executable = { command = vim.fn.exepath("codelldb"), args = { "--port", "${port}" } },
        }
    end
end

M.install_hint = "Install lldb (e.g. `sudo apt install lldb`) or run :MasonInstall codelldb."

return M
