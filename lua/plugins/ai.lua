return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        display = {
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ", -- Prompt used for interactive LLM calls
            provider = "default", -- default|telescope|mini_pick
            opts = {
              -- Show the default actions in the action palette?
              show_default_actions = true,
              -- Show the default prompt library in the action palette?
              show_default_prompt_library = true,
            },
          },
        },
        opts = {
          log_level = "DEBUG",
          language = "Chinese",
        },
        strategies = {
          chat = { adapter = "copilot" },
          inline = { adapter = "copilot" },
          agent = { adapter = "copilot" },
        },
        adapters = {
          ollama = function()
            local name = os.getenv("OLLAMA_NVIM_NAME") or "qwen"
            local model = os.getenv("OLLAMA_NVIM_MODEL") or "qwen2.5-coder:3b"

            return require("codecompanion.adapters").extend("ollama", {
              name = name,
              schema = {
                model = { default = model },
              },
            })
          end,
          deepseek = function()
            local url = os.getenv("DEEPSEEK_NVIM_URL") or nil
            local apikey = os.getenv("DEEPSEEK_API_KEY")

            return require("codecompanion.adapters").extend("deepseek", {
              env = {
                url = url,
                api_key = apikey,
              },
            })
          end,
          aliyun_deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              name = "aliyun_deepseek",
              url = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
              env = {
                api_key = function()
                  return os.getenv("ALIYUN_API_KEY")
                end,
              },
              schema = {
                model = {
                  default = "deepseek-r1",
                  choices = {
                    ["deepseek-r1"] = { opts = { can_reason = true } },
                  },
                },
              },
            })
          end,
          qwen_coder_turbo = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "qwen_coder_turbo",
              env = {
                -- optional: default value is ollama url http://127.0.0.1:11434
                url = "https://dashscope.aliyuncs.com",
                api_key = function()
                  return os.getenv("ALIYUN_API_KEY")
                end,
                -- optional: default value, override if different
                chat_url = "/compatible-mode/v1/chat/completions",
              },
              schema = {
                model = {
                  default = "qwen-coder-turbo",
                },
              },
            })
          end,
          opts = {
            show_defaults = true,
          },
        },
      })

      local progress_handler = vim.lsp.handlers["$/progress"]
      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
          local clients = vim.lsp.get_clients({ method = "progress" })
          local client_id = (clients[1] and clients[1].id) or 1
          local status, err = pcall(function()
            if request.match == "CodeCompanionRequestStarted" then
              progress_handler(nil, {
                token = "codecampion",
                value = { message = request.match, kind = "begin" },
              }, { client_id = client_id, method = "progress" })
            elseif request.match == "CodeCompanionRequestFinished" then
              progress_handler(nil, {
                token = "codecampion",
                value = { message = request.match, kind = "end" },
              }, { client_id = client_id, method = "progress" })
            end
          end)
          if not status then
            vim.notify("Error in progress handler: " .. err, vim.log.levels.ERROR)
          end
        end,
      })

      local wk = require("which-key")
      wk.add({
        { "<leader>a", "", desc = "AI" },
        { "<leader>aa", "<cmd>CodeCompanionActions<CR>", desc = "CodeCompanionActions", mode = { "n", "v" } },
        { "<leader>ab", "<cmd>CodeCompanionCmd<CR>", desc = "CodeCompanionCmd", mode = { "n", "v" } },
        { "<leader>ac", "<cmd>CodeCompanionChat toggle<CR>", desc = "CodeCompanionChat", mode = { "n" } },
        { "<leader>ac", "<cmd>CodeCompanionChat Add<CR>", desc = "CodeCompanionChat", mode = { "v" } },
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
}
