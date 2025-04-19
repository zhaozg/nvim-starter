-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set
local gs = require("gitsigns")

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
