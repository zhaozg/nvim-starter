return {
  -- add gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    pin = true,
    opts = {
      colorscheme = "gruvbox",
    },
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require('mini.tabline').setup({})
    end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    opts = {},
  },

  {
    "lewis6991/satellite.nvim",
    opts = {},
  },

  {
    "sindrets/diffview.nvim",
    opts = {
      diff_binaries = false, -- Show diffs for binaries
      use_icons = true, -- Requires nvim-web-devicons

      view = {
        -- For more info, see |diffview-config-view.x.layout|.
        default = {
          -- Config for changed files, and staged files in diff views.
          layout = "diff2_vertical",
          winbar_info = false, -- See |diffview-config-view.x.winbar_info|
        },
        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase.
          layout = "diff3_mixed",
          disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
          winbar_info = true, -- See |diffview-config-view.x.winbar_info|
        },
        file_history = {
          -- Config for changed files in file history views.
          layout = "diff2_horizontal",
          winbar_info = false, -- See |diffview-config-view.x.winbar_info|
        },
      },
      file_panel = {
        win_config = {
          position = "left", -- One of 'left', 'right', 'top', 'bottom'
          width = 25, -- Only applies when position is 'left' or 'right'
          height = 10, -- Only applies when position is 'top' or 'bottom'
        },
      },
    },
  },
}
