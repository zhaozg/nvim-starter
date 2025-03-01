-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set
local gs = require("gitsigns")

-- gitsigns 的键位映射
-- Navigation
map("n", "]g", function() gs.nav_hunk("next") end, { desc = "Next Git Hunk" })
map("n", "[g", function() gs.nav_hunk("prev") end, { desc = "Prev Git Hunk" })
-- Stage/Restore Operations
map({ "n", "v" }, "<leader>gs", function()
  if vim.opt.diff:get() then
    vim.cmd.normal({ "gg=G", bang = true })
  else
    vim.schedule(function()
      if vim.fn.reg_executing() == "" then
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end
    end)
  end
end, { desc = "Stage Git Hunk/Selection" })

map({ "n", "v" }, "<leader>gr", function()
  if vim.opt.diff:get() then
    vim.cmd.normal({ "gg=G", bang = true })
  else
    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end
end, { desc = "Reset Git Hunk/Selection" })

-- Buffer Level Operations
map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage Buffer" })
map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset Buffer" })

-- Diff Operations
map("n", "<leader>gd", function()
  gs.diffthis("~")
  vim.schedule(function()
    if vim.wo.diff then
      vim.cmd("windo diffoff")
    end
  end)
end, { desc = "Diff Against HEAD" })

map("n", "<leader>gD", function()
  gs.diffthis()
  vim.schedule(function()
    if vim.wo.diff then
      vim.cmd("windo diffoff")
    end
  end)
end, { desc = "Diff Against Index" })

-- Blame Operations
map("n", "<leader>gb", function()
  gs.blame_line({ full = true, ignore_whitespace = true })
end, { desc = "Blame Line (Full)" })

map("n", "<leader>gB", function()
  gs.toggle_current_line_blame()
end, { desc = "Toggle Line Blame" })

-- Preview Operations
map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
map("n", "<leader>gP", function()
  gs.preview_hunk_inline()
end, { desc = "Inline Preview Hunk" })

-- Text Objects
map({ "o", "x" }, "ih", function()
  if vim.bo.filetype == "NeogitStatus" then
    return
  end
  gs.select_hunk()
end, { desc = "Select Git Hunk" })
