-- return {
--   "MeanderingProgrammer/render-markdown.nvim",
--   lazy = false,
--   ft = { "markdown" },
--   opts = {
--     latex = {
--       enabled = true, -- set false to disable
--       position = "center", -- or "above" / "below"
--       -- converter = { "utftex", "latex2text" }, -- default list
--     },
--   },
-- }
return {
  "OXY2DEV/markview.nvim",
  lazy = false,

  -- Completion for `blink.cmp`
  dependencies = { "saghen/blink.cmp" },
}
