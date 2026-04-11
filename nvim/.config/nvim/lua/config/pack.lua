local gh = function(repo)
  return "https://github.com/" .. repo
end

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local data = ev.data
    if not data or not data.spec or not data.kind then
      return
    end

    if data.spec.name == "nvim-treesitter" and (data.kind == "install" or data.kind == "update") then
      vim.schedule(function()
        pcall(vim.cmd, "TSUpdate")
      end)
    end
  end,
})

vim.pack.add({
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("lewis6991/gitsigns.nvim"),
  gh("ibhagwan/fzf-lua"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("mikavilpas/yazi.nvim"),
  gh("kylechui/nvim-surround"),
  gh("mrcjkb/rustaceanvim"),
  gh("mfussenegger/nvim-dap"),
  gh("rcarriga/nvim-dap-ui"),
  gh("nvim-neotest/nvim-nio"),
  gh("mfussenegger/nvim-dap-python"),
  gh("nvim-neotest/neotest"),
  gh("nvim-neotest/neotest-python"),
  gh("nvim-lua/plenary.nvim"),
  gh("antoinemadec/FixCursorHold.nvim"),
  -- Formatting
  gh("stevearc/conform.nvim"),
  -- Git
  gh("NeogitOrg/neogit"),
  gh("sindrets/diffview.nvim"),
  -- UI
  gh("nvim-lualine/lualine.nvim"),
  gh("folke/snacks.nvim"),
  gh("folke/which-key.nvim"),
  gh("HubiRa/kaolin-dark.nvim"),
  gh("folke/todo-comments.nvim"),
  -- Markdown
  gh("OXY2DEV/markview.nvim"),
  -- Images
  gh("3rd/image.nvim"),
  -- Git
  gh("tpope/vim-fugitive"),
  -- Session
  gh("tpope/vim-obsession"),
  -- Build/dispatch
  gh("tpope/vim-dispatch"),
}, {
  load = false,
  confirm = false,
})

for _, plugin in ipairs({
  "FixCursorHold.nvim",
  "conform.nvim",
  "fzf-lua",
  "gitsigns.nvim",
  "kaolin-dark.nvim",
  "lualine.nvim",
  "mason.nvim",
  "nvim-lspconfig",
  "nvim-surround",
  "nvim-treesitter",
  "nvim-web-devicons",
  "rustaceanvim",
  "snacks.nvim",
  "todo-comments.nvim",
  "which-key.nvim",
  "yazi.nvim",
}) do
  pcall(vim.cmd.packadd, plugin)
end
