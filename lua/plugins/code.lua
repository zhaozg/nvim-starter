return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    opts = {},
  },
  {
    'andythigpen/nvim-coverage',
    after = "nvim-lua/plenary.nvim",
    config = function()
      require("coverage").setup({
        auto_reload = true,
      })
    end
  }
}
