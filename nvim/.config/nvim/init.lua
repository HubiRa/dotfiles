-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Enable relative number from the start
vim.o.relativenumber = true

-- simplify escaping from terminal mode
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- molten
--  vim.g.molten_nvim_socket = "/tmp/nvimsocket"  -- Same path as in WezTerm configuration

-- -- magma
-- vim.g.magma_automatically_open_output = false
-- vim.g.magma_image_provider = "kitty"
-- vim.g.magma_output_window_borders = true

-- set window to opaque level of terminal
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])

-- map <space>e :lua vim.diagnostic.open_float(0, {scope="line"})<CR>
vim.api.nvim_set_keymap("n", "<leader>gl", ":lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })

-- Remove (or change) the gray background in the sign/line/fold columns
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" }) -- optional
-- vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#84AAAA"})
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
vim.api.nvim_set_hl(0, "TermCursor", { bg = "#aa8788", fg = "#191a22" })
vim.api.nvim_set_hl(0, "Search", { bg = "#aa8788", fg = "#191a22" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#aa8788", fg = "#191a22" })
vim.api.nvim_set_hl(0, "TermCursor", { bg = "#aa8788", fg = "#191a22" })

-- zen mode backderop ppacity
vim.api.nvim_set_hl(0, "ZenBg", { ctermbg = 0 })
-- vim.api.nvim_set_hl(0, "StatusLine", { bg = "none"})
-- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
--
-- Switch to the next tab (tabpage)
-- vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { desc = "Next Tab" })
-- Switch to the previous tab (tabpage)
-- vim.keymap.set("n", "<S-Tab>", ":tabprevious<CR>", { desc = "Previous Tab" })
