pcall(function()
  require("vim._core.ui2").enable()
end)

local ok, _ = pcall(vim.cmd.colorscheme, "kaolin-dark")
if not ok then
  vim.cmd.colorscheme("habamax") -- fallback until plugin is installed
end

-- Terminal colors (kaolin-dark palette)
vim.g.terminal_color_0 = "#18181b"  -- black
vim.g.terminal_color_1 = "#cd5c60"  -- red
vim.g.terminal_color_2 = "#6fb593"  -- green
vim.g.terminal_color_3 = "#dbac66"  -- yellow
vim.g.terminal_color_4 = "#968cc7"  -- blue
vim.g.terminal_color_5 = "#ab98b5"  -- magenta
vim.g.terminal_color_6 = "#4d9391"  -- cyan
vim.g.terminal_color_7 = "#adadb9"  -- white
vim.g.terminal_color_8 = "#303035"  -- bright black
vim.g.terminal_color_9 = "#cd5c60"  -- bright red
vim.g.terminal_color_10 = "#68f3ca" -- bright green
vim.g.terminal_color_11 = "#cd9575" -- bright yellow
vim.g.terminal_color_12 = "#80bcb6" -- bright blue
vim.g.terminal_color_13 = "#766884" -- bright magenta
vim.g.terminal_color_14 = "#80bcb6" -- bright cyan
vim.g.terminal_color_15 = "#e6e6e8" -- bright white

local function transparent_highlights()
  local groups = {
    "Normal",
    "NormalNC",
    "SignColumn",
    "LineNr",
    "FoldColumn",
    "ColorColumn",
    "CursorLine",
    "EndOfBuffer",
    "WinSeparator",
    -- Floating windows
    "NormalFloat",
    "FloatBorder",
    "FloatTitle",
    -- Popup menu
    "Pmenu",
    "PmenuSbar",
    -- Telescope/picker
    "TelescopeNormal",
    "TelescopeBorder",
    "TelescopePromptNormal",
    "TelescopePromptBorder",
    "TelescopeResultsNormal",
    "TelescopeResultsBorder",
    "TelescopePreviewNormal",
    "TelescopePreviewBorder",
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
  end

  -- Gray line numbers
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#6b7089", bg = "none" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#a0a8b7", bg = "none" })

  vim.api.nvim_set_hl(0, "TermCursor", { bg = "#aa8788", fg = "#191a22" })
  vim.api.nvim_set_hl(0, "Search", { bg = "#aa8788", fg = "#191a22" })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#aa8788", fg = "#191a22" })
  vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = "#4c566a" })
  vim.api.nvim_set_hl(0, "ZenBg", { ctermbg = 0 })

  -- Snacks/fzf-lua picker transparency
  vim.api.nvim_set_hl(0, "FzfLuaNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FzfLuaBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "FzfLuaPreviewNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FzfLuaPreviewBorder", { bg = "none" })
end

transparent_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = transparent_highlights,
})
