  -- return {
  --   "nvim-neotest/neotest-python",
  --   config = function ()
  --       require("neotest").setup({
  --       adapters = {
  --         require("neotest-python")
  --       }
  --     })
  --   end
  -- }


return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter"
  }
  -- config = function ()
  --   require("neotest").setup({
  --     adapters = {
  --       require("neotest-python")
  --     }
  --   })
  -- end

}
