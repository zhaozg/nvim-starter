return {
  {
    "neovim/nvim-lspconfig",
    dependencies = "nvimtools/none-ls.nvim",
  },
  { "nvimtools/none-ls-extras.nvim", },
  { "zhaozg/none-ls-extend.nvim", },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "folke/neoconf.nvim",
      "nvimtools/none-ls-extras.nvim",
      "zhaozg/none-ls-extend.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      -- 动态读取 neoconf 配置
      local user = require('neoconf').get('null-ls') or {}

      local sources = {}
      for name, args in pairs(user.sources or {}) do
        if type(args) == "table" and args.enabled ~= false then
          args.enabled = nil
          local _, source = pcall(require, name);
          if not _ then
            vim.notify("null-ls: " .. name .. " not found", vim.log.levels.WARN)
            source = nil
          else
            source = source.with(args)
          end
          if source then
            table.insert(sources, source)
          end
        end
      end

      null_ls.setup({ sources = sources })

      if type(user.format)=='table' then
        vim.api.nvim_create_user_command("Format", function()
          vim.lsp.buf.format({
            async = true,          -- 异步格式化（推荐）
            timeout_ms = 3000,     -- 超时时间
            filter = function(client)
              local ft = vim.bo.filetype
              for i=1, #user.format do
                if user.format[i] == ft then
                  -- 过滤条件示例：只允许 null-ls 格式化
                  return client.name == "null-ls"
                end
              end
              return false
            end
          })
        end, { desc = "Format current buffer via LSP" })
      end

    end,
  }
}
