return {
  {
    "HakonHarnes/img-clip.nvim",
    ft = { "markdown" },
    config = function()
      require 'img-clip'.setup {
        default = {
          use_absolute_path = false,
          relative_to_current_file = true,
          prompt_for_file_name = false,
          dir_path = "img",
        }
      }
      local wk = require("which-key")
      wk.add({
        { "<localleader>p", ":PasteImage<CR>", desc = "PasteImage" },
      })
    end
  },
  {
    "kvrohit/tasks.nvim",
    config = function()
      local wk = require("which-key")
      wk.add({
        { "<localleader>t", ":ToggleTask<CR>", desc = "ToggleTask" },
        { "<localleader>u", ":UndoTask<CR>", desc = "UndoTask" },
        { "<localleader>x", ":CancelTask<CR>", desc = "CancelTask" },
      })
    end,
  },
  {
    "zk-org/zk-nvim",
    config = function()
      require("zk").setup()
    end
  },
}
