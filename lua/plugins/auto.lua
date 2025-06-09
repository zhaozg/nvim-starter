-- 在 LazyVim 的插件配置中：
return {
  {
    "folke/neoconf.nvim",

    -- Setup `require("neoconf").setup()` should be run **BEFORE** setting up
    -- any lsp server with lspconfig
    lazy = false,
    priority = 9999,
    config = function(_, opts)
      require("neoconf").setup(opts)

      local function setup_filetype()
        local user = require('neoconf').get('filetype') or {}
        for k, v in pairs(user) do
          vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
            pattern = k,
            command = "set filetype=" .. v
          })
        end
      end
      setup_filetype()

      return opts
    end
  },
  {
    "keaising/im-select.nvim",
    config = function()

      local function is_linux()
          local sysname = vim.loop.os_uname().sysname
          return sysname == "Linux"
      end

      local ime_switch = is_linux() and "ibus" or "im-select"
      local ime_select = is_linux() and "xkb:us::eng" or "im.rime.inputmethod.Squirrel.Hans"
      require("im_select").setup({
        default_command = ime_switch,
        default_im_select = ime_select,
        set_previous_events = { "InsertLeave" },
      })
    end
  },
}
