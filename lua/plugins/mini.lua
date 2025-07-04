return {
  {
    "echasnovski/mini.nvim",
    config = function(_, opts)
      require('mini.move').setup()
      require('mini.snippets').setup()
      require('mini.cursorword').setup()
      require('mini.operators').setup()
      require('mini.sessions').setup()

      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })


      require('mini.trailspace').setup()
      -- HACK: We need to disabel the mini.trailspace and enable when a new buffer is
      -- created to avoid interference with the dashboard snacks.nvim. See:
      --
      --  https://github.com/echasnovski/mini.nvim/issues/1395
      vim.g.minitrailspace_disable = true

      vim.api.nvim_create_autocmd("BufNew", {
        callback = function()
          vim.g.minitrailspace_disable = false
        end
      })
    end,
  },
}
