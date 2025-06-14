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
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = {
      tabline = {
        lualine_a = {
          { -- 当前标签页
            'buffers',
            mode = 2, -- 只显示标签页索引与名称
            tabs_color = {
              active = 'lualine_a_normal',
              inactive = 'lualine_a_inactive',
            },
            icons_enabled = true,
            symbols = {
              alternate_file = '#',
              directory = '',
            },
          }
        },
        lualine_z = {
          {
            -- 当前窗口列表
            'windows',
            show_filename_only = true,
            show_modified_status = true,
            mode = 1,
            icons_enabled = true,
            filetype_names = {
              TelescopePrompt = '',
              NvimTree = '',
              dashboard = '',
            },
            symbols = {
              modified = '●',        -- 已修改
              alternate_file = '#',  -- 备用文件
              directory = '',       -- 目录
            },
          }
        }
      }
    }
  },

  {
    "norcalli/nvim-colorizer.lua",
    opts = {},
  },

  {
    "lewis6991/satellite.nvim",
    opts = {
      current_only = true,
      handlers = {
        cursor = {
          enable = true,
          overlap = true
        },
        search = {
          enable = true,
          overlap = true
        },
        diagnostic = {
          enable = true,
          overlap = true,
          signs = {'-', '=', '≡'},
          min_severity = vim.diagnostic.severity.HINT,
        },
        gitsigns = {
          enable = true,
          overlap = true,
          signs = { -- can only be a single character (multibyte is okay)
            add = "│",
            change = "~",
            delete = "-",
          },
        },
        marks = {
          enable = true,
          overlap = true,
          key =  'm',
          show_builtins = true, -- shows the builtin marks like [ ] < >
        },
      },
    },
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
