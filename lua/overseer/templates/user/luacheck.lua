local M = {}

M.template = {
  name = "Luacheck",
  desc = "Static analysis for Lua code",
  params = {
    scope = {
      type = "enum",
      choices = { "file", "project" },
      default = "file",
      desc = "Check scope (current file or project)"
    },
    args = {
      type = "string",
      optional = true,
      desc = "Additional luacheck arguments"
    }
  },
  builder = function(params)
    local cmd = "luacheck"
    local args = {}

    if params.scope == "file" then
      table.insert(args, vim.fn.expand("%:p"))
    else
      table.insert(args, ".")
    end

    vim.list_extend(args, {
      "--formatter", "plain",
      "--codes",
    })

    local global_config = vim.fn.expand("~/.luacheckrc")
    if vim.fn.filereadable(global_config) == 1 then
      table.insert(args, "--config")
      table.insert(args, global_config)
    end

    if params.args and params.args ~= "" then
      vim.list_extend(args, vim.split(params.args, "%s+"))
    end

    return {
      name = "Luacheck: " .. (params.scope == "file"
             and vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
             or "Project"),
      cmd = cmd,
      args = args,
      cwd = vim.fn.getcwd(),
      components = {
        {
          "on_output_quickfix",
          errorformat = "%f:%l:%c: (%*[^)]) %m",
          open = true, open_height = 8,
        },
        "default",
      }
    }
  end,
  condition = {
    filetype = { "lua" }
  }
}

M.setup = function(opts)
  opts = vim.tbl_deep_extend("force", M.template, opts or {})
  require("overseer").register_template(opts)

  -- Luacheck
  vim.api.nvim_create_user_command("Luacheck", function(params)
    local template_params = {
      args = params.args
    }

    if params.bang then
      template_params.scope = "project"
    end

    require("overseer").run_template({
      name = "Luacheck",
      params = template_params
    })
  end, {
    desc = "Run predefined Luacheck task",
    nargs = "*",
    bang = true,
    complete = function(_ArgLead, _CmdLine, _CursorPos)
      return {
        "--ignore", "--only", "--enable", "--disable",
        "--config", "--formatter", "--jobs"
      }
    end
  })
end

return M
