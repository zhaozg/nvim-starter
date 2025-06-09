return {
  {
    "stevearc/overseer.nvim",
    lazy = false,
    dependencies = {
      "folke/neoconf.nvim",
    },

    config = function(_, opts)
      require("overseer").setup(opts)

      local user = require('neoconf').get('overseer') or {}
      if user.templates then
        for k, v in pairs(user.templates) do
          local tpl = require(string.format("overseer.templates.%s", k))
          tpl.setup(v)
        end
      end

      -- Make
      vim.api.nvim_create_user_command("Make", function(params)
        -- Insert args at the '$*' in the makeprg
        local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
        if num_subs == 0 then
          cmd = cmd .. " " .. params.args
        end
        local task = require("overseer").new_task({
          cmd = vim.fn.expandcmd(cmd),
          components = {
            { "on_output_quickfix", open = not params.bang, open_height = 8 },
            "default",
          },
        })
        task:start()
      end, {
        desc = "Run your makeprg as an Overseer task",
        nargs = "*",
        bang = true,
      })
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- 关键配置：确保监听诊断
      auto_preview = true, -- 自动预览
      use_diagnostic_signs = true, -- 使用诊断符号
      action_keys = {
        close = "q", -- 关闭窗口
        refresh = "r", -- 手动刷新
      },
      modes = {
        diagnostics = { auto_open = false },
        -- 配置workspace_diagnostics模式
        workspace_diagnostics = {
          mode = "workspace_diagnostics",
          focus = true,
          filter = { severity = vim.diagnostic.severity.ERROR }
        },
        quickfix = {
          mode = "quickfix",
          focus = true
        }
      }
    },
  },
}
