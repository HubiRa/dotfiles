return {
  "folke/todo-comments.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  require('todo-comments').setup()
  -- opts = {
  --   -- your configuration comes here
  --   -- or leave it empty to use the default settings
  --   -- refer to the configuration section below
  -- }
}
