-- return {
--   "ibhagwan/fzf-lua",
--   lazy = false,
--   -- optional for icon support
--   dependencies = { "nvim-tree/nvim-web-devicons" },
--   config = function()
--     -- calling `setup` is optional for customization
--     require("fzf-lua").setup({})
--   end
-- }
return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {},
}
