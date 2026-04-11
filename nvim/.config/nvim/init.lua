if vim.fn.has("nvim-0.12") == 0 then
  vim.api.nvim_echo({
    { "This config requires Neovim 0.12+\n", "ErrorMsg" },
    { "This config requires Neovim 0.12+", "WarningMsg" },
  }, true, {})
  return
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- rustaceanvim reads this global during startup.
vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = true,
      },
    },
  },
}

require("config.options")
require("config.pack")
require("config.ui")
require("config.keymaps")
require("config.plugins")
require("config.lsp")
require("config.autocmds")
