vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.updatetime = 200
vim.o.timeoutlen = 300
vim.o.ttimeout = true
vim.o.ttimeoutlen = 10
vim.o.undofile = true
vim.o.laststatus = 3
vim.o.winborder = "rounded"
vim.o.completeopt = "menuone,noselect,popup,fuzzy"
vim.o.autocomplete = true
vim.o.exrc = true
vim.o.shelltemp = false

vim.cmd("syntax enable")

local nu = vim.fn.exepath("nu")
if nu ~= "" then
  vim.o.shell = nu
  vim.o.shellcmdflag = "-c"
end

vim.opt.fillchars = {
  eob = " ",
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
}
vim.opt.shortmess:append({ W = true, c = true })
