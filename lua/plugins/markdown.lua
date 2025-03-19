return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    pin = true,
    config = function()
      local wk = require("which-key")
      wk.add({
        { "<localleader>P", "<cmd>MarkdownPreview<CR>", desc = "MarkdownPreview" },
      })
    end
  },
  {
    'junegunn/vim-easy-align',
    config = function()
      local wk = require("which-key")
      wk.add({
        { "<localleader>a", "<Plug>(EasyAlign)", desc = "EasyAlign" },
        { "<localleader>ai", "<Plug>(LiveEasyAlign)", desc = "LiveEasyAlign", mode= { "n" } },
        { '<localleader>a"', '<Plug>(EasyAlign)ip"', desc = 'Align "', mode= { "n", "v" } },
        { "<localleader>a#", "<Plug>(EasyAlign)ip#", desc = "Align #", mode= { "n", "v" } },
        { "<localleader>a&", "<Plug>(EasyAlign)ip&", desc = "Align &", mode= { "n", "v" } },
        { "<localleader>a,", "<Plug>(EasyAlign)ip,", desc = "Align ,", mode= { "n", "v" } },
        { "<localleader>a.", "<Plug>(EasyAlign)ip.", desc = "Align .", mode= { "n", "v" } },
        { "<localleader>a:", "<Plug>(EasyAlign)ip:", desc = "Align :", mode= { "n", "v" } },
        { "<localleader>a=", "<Plug>(EasyAlign)ip=", desc = "Align =", mode= { "n", "v" } },
        { "<localleader>ac", "<Plug>(EasyAlign)ip-[ *]+/r0", desc = "AlignCode", mode= { "n", "v" } },
        { "<localleader>at", "<Plug>(EasyAlign)ip*|", desc = "AlignTable", mode= { "n", "v" } },
        { "<localleader>a|", "<Plug>(EasyAlign)ip|", desc = "Align |", mode= { "n", "v" } },
      })
    end
  },
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
