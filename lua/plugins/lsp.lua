return {
  {
    "neovim/nvim-lspconfig",
    dependencies = "nvimtools/none-ls.nvim",
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "folke/neoconf.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      -- 动态读取 neoconf 配置
      local get_clang_format_args = function()
        local conf = require("neoconf").get("clang_format") or {}
        local args = {}

        -- 添加 style 参数（优先项目配置，否则用默认）
        if conf.style then
          table.insert(args, "--style=" .. conf.style)
        else
          table.insert(args, "--style=file") -- 默认从 .clang-format 读取
        end

        -- 添加额外参数
        if conf.extra_args then
          vim.list_extend(args, conf.extra_args)
        end

        return args
      end

      vim.api.nvim_create_user_command("LspFormat", function()
        vim.lsp.buf.format({
          async = true,          -- 异步格式化（推荐）
          timeout_ms = 3000,     -- 超时时间
          filter = function(client)
            local ft = vim.bo.filetype
            if (ft == "c" or ft == "cpp" or ft == "h" or ft == "hpp") then
              -- 过滤条件示例：只允许 null-ls 格式化
              return client.name == "null-ls"
            end
            return true
          end
        })
      end, { desc = "Format current buffer via LSP" })

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.clang_format.with({
            extra_args = get_clang_format_args, -- 动态参数
            extra_filetypes = { "c", "cpp", "h", "hpp" }, -- 指定文件类型
          }),
        },
      })
    end,
  }
}
