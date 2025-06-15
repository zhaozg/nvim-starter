return {
  { 'tpope/vim-repeat' },
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
