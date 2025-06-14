return {
  {
    "echasnovski/mini.nvim",
    config = function(_, opts)
      -- active mini.snippets
      require('mini.snippets').setup()
      require('mini.move').setup()
    end,
  },
}
