return {
  {
    "L3MON4D3/LuaSnip",
    build = function()
      os.execute("make install_jsregexp")
    end,
    config = function()
      local loadder = require("luasnip.loaders.from_snipmate")
      if vim.fn.isdirectory("~/.snippets") == 1 then
        loadder.lazy_load { path = "~/.snippets" }
      end
    end
  },
  {
    "cappyzawa/trim.nvim",
    opts = {
      ft_blocklist = {"markdown"},

    }
  }
}
