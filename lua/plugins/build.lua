return {
  {
    "stevearc/overseer.nvim",
    opts = {
      -- 启用 VS Code 任务导入
      templates = { "builtin", "vscode" },
      -- 关键配置：确保使用诊断组件
      default_task = {
        components = {
          -- 必须添加的组件
          { "on_output_parse", parser = "errorformat" }, -- 使用errorformat解析
          "on_result_diagnostics", -- 生成诊断
          "on_result_diagnostics_quickfix", -- 发送到quickfix
          { "display", open = "auto" } -- 自动打开任务窗口
        },
        on_complete = function(task)
          -- 任务完成后刷新诊断
          if task.status == "FAILED" then
            -- 将错误发送到 Trouble
            vim.schedule(function()
              vim.diagnostic.reset(nil, task.bufnr)
              require("trouble").refresh()
              require("trouble").open("workspace_diagnostics")
            end)
          end
        end
      },
      -- 内置解析器配置
      parsers = {
        errorformat = {
          errorformat = "%f:%l:%c: %t%*[^:]: %m", -- 通用错误格式
          signs = {
            { name = "Error", text = "" },
            { name = "Warning", text = "" },
            { name = "Info", text = "" }
          }
        }
      }
    },
    config = function(_, opts)
      require("overseer").setup(opts)

      -- 自定义任务命令
      vim.api.nvim_create_user_command("RunTask", function(_opts)
        local task_name = _opts.args
        require("overseer").run_template({ name = task_name }, function(task)
          if task then
            -- 确保添加诊断组件
            task:add_component({ "on_output_parse", parser = "errorformat" })
            task:add_component("on_result_diagnostics")
            task:add_component("on_result_diagnostics_quickfix")
          end
        end)
      end, { nargs = 1, complete = require("overseer").task_template_complete })
    end,
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
    keys = {
      -- 快捷键映射
      { "<leader>tt", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
      { "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>tq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List" },
      {
        "<leader>tr",
        function()
          require("trouble").open()
          vim.cmd("RunTask build")
        end,
        desc = "Run Build with Trouble",
      },
    }
  },
}
