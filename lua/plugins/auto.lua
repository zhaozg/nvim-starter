-- 在 LazyVim 的插件配置中：
return {
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
