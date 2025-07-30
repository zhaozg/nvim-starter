return {
  {
    "ravitemer/codecompanion-history.nvim"
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "rcarriga/nvim-notify",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "folke/neoconf.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
    config = function()

      local function get_Adapter(name, provider, model, opts)
        if name == 'deepseek' and (provider=='deepseek' or provider==nil) then
          local url = os.getenv("DEEPSEEK_API_URL") or "https://api.deepseek.com"
          local apikey = os.getenv("DEEPSEEK_API_KEY")
          if apikey then
            return require("codecompanion.adapters").extend("deepseek", {
              schema = {
                model = {
                  default = model or "deepseek-chat"
                }
              },
              env = {
                url = url,
                api_key = function()
                  return apikey
                end
              },
            })
          end
        elseif provider=='ollama' then
          model = model or name

          return require("codecompanion.adapters").extend("ollama", {
            name = name,
            schema = {
              model = { default = model },
              choices = {
                [model] = { opts = opts },
              },
            },
          })
        elseif provider=='aliyun' then
          local url = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions"
          model = model or name
          name = model ..'@'.. provider
          local adapter = model:match('^deepseek') and "deepseek" or "openai_compatible"
          local apikey = os.getenv("ALIYUN_API_KEY")

          if apikey then
            return require("codecompanion.adapters").extend(adapter, {
              name = name,
              url = url,
              env = {
                api_key = function()
                  return apikey
                end,
              },
              schema = {
                model = {
                  default = model,
                  choices = {
                    [model] = { opts = opts },
                  },
                },
              },
            })
          end
        end
      end

      local adapters = { opts = { show_defaults = false } }
      local user = require('neoconf').get('codecompanion') or {}
      for k, v in pairs(user.adapters or {}) do
        local name = v.name or k
        adapters[k] = get_Adapter(name, v.provider, v.model, v.opts)
      end

      require("codecompanion").setup({
        prompt_library = user.prompt_library,
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
          log_level = "INFO",
          language = "English", -- Language used for LLM calls
        },
        strategies = {
          chat = {
            adapter = "copilot",
            slash_commands = {
              ["file"] = {
                opts = {
                  provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                  contains_code = true,
                },
              },
              ["buffer"] = {
                opts = {
                  provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                  contains_code = true,
                },
              },
            },
          },
          inline = { adapter = "copilot" },
          agent = { adapter = "copilot" },
        },
        extensions = {
          history = {
            enabled = true,
            opts = {
              -- Picker interface (auto resolved to a valid picker)
              picker = "default", --- ("telescope", "snacks", "fzf-lua", or "default")
            }
          }
        },
        adapters = adapters
      })

      local progress_handler = vim.lsp.handlers["$/progress"]
      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

      local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      local spinner_index = 0
      local notify = require("notify")
      local notice

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
          local clients = vim.lsp.get_clients({ method = "progress" })
          local client_id = clients[1] and clients[1].id
          if not client_id then
            spinner_index = (spinner_index % #spinner_frames) + 1

            local msg = "正在处理..." .. spinner_frames[spinner_index]
            if request.match == "CodeCompanionRequestFinished" then
              msg = "完成处理"
            end
            notice = notify(msg, vim.log.levels.INFO, {
              render = "minimal",
              minimum_width = 10,
              top_down = false,
              title = "CodeCompanion",
              replace = notice,
            })

            return
          end

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
        { "<leader>a ", "<cmd>CodeCompanionActions<CR>", desc = "CodeCompanionActions", mode = { "n", "v" } },
        { "<leader>ab", "<cmd>CodeCompanionCmd<CR>", desc = "CodeCompanionCmd", mode = { "n", "v" } },
        { "<leader>ac", "<cmd>CodeCompanionChat toggle<CR>", desc = "CodeCompanionChat", mode = { "n" } },
        { "<leader>ac", "<cmd>CodeCompanionChat Add<CR>", desc = "CodeCompanionChat", mode = { "v" } },
      })
    end,
  },
}
