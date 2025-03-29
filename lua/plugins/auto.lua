-- 在 LazyVim 的插件配置中：
return {
  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    opts = function(_, opts)
      local function setup_filetype()
        local conf = require("neoconf").get("filetype") or {}
        for k, v in pairs(conf) do
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
      require("im_select").setup({
        default_command = "im-select",
        -- macOS 配置
        default_im_select = "im.rime.inputmethod.Squirrel.Hans",
        -- Linux 配置（Fcitx）
        -- default_im_select = "fcitx",
        set_previous_events = { "InsertLeave" },
      })
    end
  }
}
