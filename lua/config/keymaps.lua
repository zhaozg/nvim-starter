-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set
local gs = require("gitsigns")

vim.opt.clipboard="unnamedplus"

local function is_linux()
    local sysname = vim.loop.os_uname().sysname
    return sysname == "Linux"
end

local function is_macos()
    local sysname = vim.loop.os_uname().sysname
    return sysname == "Darwin"
end

if is_linux() then
  vim.keymap.set('v', '<A-c>', '"+y', { noremap = true })      -- 可视模式复制
  vim.keymap.set('n', '<A-v>', '"+p', { noremap = true })      -- 普通模式粘贴
  vim.keymap.set('i', '<A-v>', '<C-o>"+p', { noremap = true }) -- 插入模式粘贴
elseif is_macos() then
  vim.keymap.set('v', '<D-c>', '"+y', { noremap = true })      -- 可视模式复制
  vim.keymap.set('n', '<D-v>', '"+p', { noremap = true })      -- 普通模式粘贴
  vim.keymap.set('i', '<D-v>', '<C-o>"+p', { noremap = true }) -- 插入模式粘贴
end

-- gitsigns 的键位映射
-- Navigation
map("n", "]g", function() gs.nav_hunk("next") end, { desc = "Next Git Hunk" })
map("n", "[g", function() gs.nav_hunk("prev") end, { desc = "Prev Git Hunk" })

-- Text Objects
map({ "o", "x" }, "ih", function()
  if vim.bo.filetype == "NeogitStatus" then
    return
  end
  gs.select_hunk()
end, { desc = "Select Git Hunk" })
