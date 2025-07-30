local vim = vim

if vim.fn.exists("g:neovide") == 0 then
  return {}
end
vim.g.neovide_remember_window_size = true
vim.g.neovide_fullscreen = true
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_no_idle = false
vim.g.neovide_profiler = false
vim.g.neovide_touch_drag_timeout = 0.1
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_cursor_trail_length = 0.1
vim.g.neovide_cursor_unfocused_outline_width = 0.1
vim.g.neovide_cursor_antialiasing = false
vim.g.neovide_cursor_vfx_mode = ""
vim.g.neovide_input_use_logo = true
vim.g.neovide_input_macos_option_key_is_meta = "only_left"

local utils = require("utils")
-- 检查是否为 Linux 系统

if utils.is_linux() then
  vim.g.gui_font_default_size = 14
else
  vim.g.gui_font_default_size = 21.5
end
vim.g.gui_font_size = vim.g.gui_font_default_size

vim.g.guifont_face = "Hack Nerd Font Mono,霞鹜文楷等宽"
vim.g.guifontwide_face = "霞鹜文楷等宽"

local RefreshGuiFont = function()
  if type(vim.g.guifont_face) ~= "nil" then
    vim.opt.guifont = string.format("%s:h%s", vim.g.guifont_face, vim.g.gui_font_size)
  end
  if type(vim.g.guifontwide_face) ~= "nil" then
    vim.opt.guifontwide = string.format("%s:h%s", vim.g.guifontwide_face, vim.g.gui_font_size)
  end
end

local ResizeGuiFont = function(delta)
  vim.g.gui_font_size = vim.g.gui_font_size + delta
  RefreshGuiFont()
end

local ResetGuiFont = function()
  vim.g.gui_font_size = vim.g.gui_font_default_size
  RefreshGuiFont()
end

-- Call function on startup to set default value
ResetGuiFont()

-- Dynamic change font size

vim.api.nvim_set_keymap("n", "<A-=>", "", {
  noremap = true,
  silent = true,
  callback = function()
    ResizeGuiFont(0.5)
  end,
})
vim.api.nvim_set_keymap("n", "<A-->", "", {
  noremap = true,
  silent = true,
  callback = function()
    ResizeGuiFont(-0.5)
  end,
})
vim.api.nvim_set_keymap("n", "<A-0>", "", {
  noremap = true,
  silent = true,
  callback = function()
    ResetGuiFont()
  end,
})

-- system clipboard {{{
if utils.is_linux() then
  vim.g.neovide_input_use_logo = 0

  -- copy
  vim.api.nvim_set_keymap("i", "<M-c>", '"+y', { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<M-c>", '"+y', { noremap = true, silent = true })

  -- pasta
  vim.api.nvim_set_keymap("i", "<M-v>", "+p", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<M-v>", "+p", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<M-v>", "+p", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<M-v>", "+p", { noremap = true, silent = true })

  -- undo
  vim.api.nvim_set_keymap("n", "<M-z>", '"u', { noremap = true, silent = true })
  vim.api.nvim_set_keymap("i", "<M-z>", "<Esc>ua", { noremap = true, silent = true })
elseif utils.is_macos() then
  vim.g.neovide_input_use_logo = 1

  vim.api.nvim_set_keymap("i", "<D-c>", '"+y', { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<D-c>", '"+y', { noremap = true, silent = true })

  -- pasta
  vim.api.nvim_set_keymap("n", "<D-v>", '"+P', { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<D-v>", '"+P', { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<D-v>", '"+P', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('c', '<D-v>', '<C-R>+', { noremap = true })
  vim.api.nvim_set_keymap("i", "<D-v>", '<ESC>l"+Pli', { noremap = true, silent = true })

  -- undo
  vim.api.nvim_set_keymap("n", "<D-z>", '"u', { noremap = true, silent = true })
  vim.api.nvim_set_keymap("i", "<D-z>", "<Esc>ua", { noremap = true, silent = true })
end

-- system clipboard }}}

vim.api.nvim_set_keymap("n", "<leader>tw", "<cmd>let g:neovide_fullscreen = !g:neovide_fullscreen<cr>", {})

-- {{ IME support for neovide
local function set_ime(args)
  if args.event:match("Enter$") then
    vim.g.neovide_input_ime = true
  else
    vim.g.neovide_input_ime = false
  end
end

local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  group = ime_input,
  pattern = "*",
  callback = set_ime
})

vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
  group = ime_input,
  pattern = "[/\\?]",
  callback = set_ime
})
-- }}

return {}
