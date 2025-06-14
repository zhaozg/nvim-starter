local M = {}

function M.is_linux()
    local sysname = vim.loop.os_uname().sysname
    return sysname == "Linux"
end

function M.is_macos()
    local sysname = vim.loop.os_uname().sysname
    return sysname == "Darwin"
end

return M
