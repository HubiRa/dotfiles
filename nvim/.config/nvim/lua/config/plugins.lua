local ok, mason = pcall(require, "mason")
if ok then
  mason.setup({
    ui = {
      border = "rounded",
    },
  })

  vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
  vim.api.nvim_create_user_command("MasonInstallCore", function()
    vim.cmd(table.concat({
      "MasonInstall",
      "lua-language-server",
      "stylua",
      "prettier",
      "pyright",
      "ruff",
      "html-lsp",
      "css-lsp",
      "json-lsp",
      "yaml-language-server",
      "bash-language-server",
      "marksman",
      "debugpy",
    }, " "))
  end, { desc = "Install core Mason packages" })
end

pcall(function()
  require("lualine").setup({
    options = {
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = { statusline = { "dashboard", "lazy" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end)

pcall(function()
  local wk = require("which-key")
  wk.setup({
    preset = "helix", -- or "classic", "modern"
    delay = 300,
  })
  -- Register group labels
  wk.add({
    { "<leader>b", group = "buffer" },
    { "<leader>c", group = "code" },
    { "<leader>d", group = "debug" },
    { "<leader>f", group = "file/find" },
    { "<leader>g", group = "git" },
    { "<leader>s", group = "search" },
    { "<leader>t", group = "test/terminal" },
    { "<leader>u", group = "ui/toggle" },
    { "<leader>w", group = "windows", proxy = "<c-w>" },
    { "<leader>x", group = "diagnostics" },
  })
  -- Show all keymaps (use snacks picker instead, which-key shows on delay)
  vim.keymap.set("n", "<leader>?", "<cmd>WhichKey<cr>", { desc = "Show keymaps" })
end)

pcall(function()
  require("nvim-surround").setup({})
end)

pcall(function()
  require("gitsigns").setup({
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 200,
    },
  })
end)

-- nvim-treesitter v1.0+ only handles parser installation
-- Highlighting is built into Neovim 0.12+
pcall(function()
  local ts_lua = vim.api.nvim_get_runtime_file("lua/nvim-treesitter", false)[1]
  if ts_lua then
    local ts_root = vim.fn.fnamemodify(ts_lua, ":h:h")
    local ts_runtime = ts_root .. "/runtime"
    if vim.fn.isdirectory(ts_runtime) == 1 and not vim.o.runtimepath:find(vim.pesc(ts_runtime), 1, true) then
      vim.opt.runtimepath:append(ts_runtime)
    end
  end

  local ts_install = require("nvim-treesitter.install")
  ts_install.ensure_installed({
    "bash", "c", "css", "dockerfile", "go", "html", "javascript",
    "json", "lua", "markdown", "markdown_inline", "nix", "python",
    "query", "regex", "rust", "toml", "tsx", "typescript", "vim",
    "vimdoc", "yaml",
  })
end)

-- Enable treesitter highlighting for normal file buffers (Neovim 0.12+ native)
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  callback = function(args)
    local bt = vim.bo[args.buf].buftype
    if bt ~= "" and bt ~= "acwrite" then
      return
    end
    pcall(vim.treesitter.start, args.buf)
  end,
})

pcall(function()
  local fzf = require("fzf-lua")

  fzf.setup({
    winopts = {
      preview = {
        default = "bat",
      },
    },
    defaults = {
      query = "",
    },
  })

  -- Wrapper: remember window, open file there even if terminal
  local function pick_file_in_current_win(picker_fn, opts)
    return function()
      local win = vim.api.nvim_get_current_win()
      local was_term = vim.bo.buftype == "terminal"

      picker_fn(vim.tbl_extend("force", opts or {}, {
        actions = {
          ["default"] = function(selected)
            if not selected or #selected == 0 then return end
            local file = selected[1]
            vim.api.nvim_set_current_win(win)
            if was_term or vim.bo.buftype == "terminal" then
              vim.cmd("enew")
            end
            vim.cmd("edit " .. vim.fn.fnameescape(file))
          end,
        },
      }))
    end
  end

  local map = vim.keymap.set

  -- Top-level shortcuts
  map("n", "<leader><space>", pick_file_in_current_win(fzf.files, { query = "" }), { desc = "Find files" })
  map("n", "<leader>,", function() fzf.buffers({ no_term_buffers = false }) end, { desc = "Switch buffer" })
  map("n", "<leader>/", fzf.live_grep, { desc = "Grep" })
  map("n", "<leader>:", fzf.command_history, { desc = "Command history" })

  -- Find
  map("n", "<leader>ff", pick_file_in_current_win(fzf.files, { query = "" }), { desc = "Find files" })
  map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
  map("n", "<leader>fc", function() fzf.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find config file" })
  map("n", "<leader>fb", function() fzf.buffers({ no_term_buffers = false }) end, { desc = "Buffers" })
  map("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })

  -- Search
  map("n", "<leader>sb", fzf.blines, { desc = "Buffer lines" })
  map("n", "<leader>sc", fzf.commands, { desc = "Commands" })
  map("n", "<leader>sd", fzf.diagnostics_document, { desc = "Diagnostics" })
  map("n", "<leader>sh", fzf.help_tags, { desc = "Help" })
  map("n", "<leader>sk", fzf.keymaps, { desc = "Keymaps" })
  map("n", "<leader>sm", fzf.marks, { desc = "Marks" })
  map("n", "<leader>sr", fzf.registers, { desc = "Registers" })
  map("n", "<leader>ss", fzf.lsp_document_symbols, { desc = "LSP symbols" })
  map("n", "<leader>sw", fzf.grep_cword, { desc = "Grep word" })

  -- Git
  map("n", "<leader>gc", fzf.git_commits, { desc = "Git commits" })
  map("n", "<leader>gs", fzf.git_status, { desc = "Git status" })

  -- Save/Quit
  map("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save" })
  map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
end)

pcall(function()
  local snacks = require("snacks")
  snacks.setup({
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scratch = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    picker = { enabled = false },
    terminal = { enabled = true },
    lazygit = { enabled = true },
    scroll = { enabled = false },
    zen = { enabled = false },
    bufdelete = { enabled = true },
    toggle = { enabled = true },
  })

  local map = vim.keymap.set

  map("n", "<leader>lg", function() snacks.lazygit() end, { desc = "LazyGit" })
  map("n", "<leader>bd", function() snacks.bufdelete() end, { desc = "Delete buffer" })
  map("n", "<leader>bD", function() snacks.bufdelete.all() end, { desc = "Delete all buffers" })
  map("n", "<leader>un", function() snacks.notifier.hide() end, { desc = "Dismiss notifications" })
  map("n", "<leader>tt", function() snacks.terminal() end, { desc = "Toggle terminal" })
  map("n", "<c-/>", function() snacks.terminal() end, { desc = "Toggle terminal" })
  map("n", "<leader>.", function() snacks.scratch() end, { desc = "Scratch buffer" })
  map("n", "<leader>n", function() snacks.notifier.show_history() end, { desc = "Notification history" })
  map("n", "]]", function() snacks.words.jump(1) end, { desc = "Next reference" })
  map("n", "[[", function() snacks.words.jump(-1) end, { desc = "Prev reference" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>bprev<cr>", { desc = "Prev buffer" })
  map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
end)

pcall(function()
  require("yazi").setup({
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  })

  local function yazi_if_not_term(cmd)
    return function()
      if vim.bo.buftype == "terminal" then
        vim.notify("Cannot open Yazi from terminal buffer", vim.log.levels.WARN)
        return
      end
      vim.cmd(cmd)
    end
  end

  vim.keymap.set("n", "<leader>-", yazi_if_not_term("Yazi"), { desc = "Open Yazi at current file" })
  vim.keymap.set("n", "<leader>cw", yazi_if_not_term("Yazi cwd"), { desc = "Open Yazi in cwd" })
  vim.keymap.set("n", "<c-up>", "<cmd>Yazi toggle<cr>", { desc = "Resume Yazi session" })
end)

local dap_loaded = false
local function load_dap()
  if dap_loaded then
    return true
  end
  for _, plugin in ipairs({ "nvim-dap", "nvim-dap-ui", "nvim-nio", "nvim-dap-python" }) do
    pcall(vim.cmd.packadd, plugin)
  end

  local ok_dap, dap = pcall(require, "dap")
  local ok_dapui, dapui = pcall(require, "dapui")
  if not (ok_dap and ok_dapui) then
    return false
  end

  dapui.setup()
  pcall(function()
    require("dap-python").setup("python3")
  end)

  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end

  vim.fn.sign_define("DapBreakpoint", { text = "❄️", texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "", linehl = "", numhl = "" })

  dap_loaded = true
  return true, dap
end

vim.keymap.set("n", "<leader>db", function()
  local ok, dap = load_dap()
  if ok then dap.toggle_breakpoint() end
end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  local ok, dap = load_dap()
  if ok then dap.set_breakpoint() end
end, { desc = "Set conditional breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
  local ok, dap = load_dap()
  if ok then dap.continue() end
end, { desc = "Continue" })
vim.keymap.set("n", "<leader>ds", function()
  local ok, dap = load_dap()
  if ok then dap.step_into() end
end, { desc = "Step into" })
vim.keymap.set("n", "<leader>dn", function()
  local ok, dap = load_dap()
  if ok then dap.step_over() end
end, { desc = "Step over" })

local neotest_loaded = false
local function load_neotest()
  if neotest_loaded then
    return true, require("neotest")
  end
  for _, plugin in ipairs({ "plenary.nvim", "nvim-nio", "neotest", "neotest-python" }) do
    pcall(vim.cmd.packadd, plugin)
  end

  local ok, neotest = pcall(require, "neotest")
  if not ok then
    return false
  end

  neotest.setup({
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
      }),
    },
  })

  neotest_loaded = true
  return true, neotest
end

vim.keymap.set("n", "<leader>tr", function()
  local ok, neotest = load_neotest()
  if ok then neotest.run.run() end
end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function()
  local ok, neotest = load_neotest()
  if ok then neotest.run.run(vim.fn.expand("%")) end
end, { desc = "Run file tests" })
vim.keymap.set("n", "<leader>ts", function()
  local ok, neotest = load_neotest()
  if ok then neotest.summary.toggle() end
end, { desc = "Toggle test summary" })
vim.keymap.set("n", "<leader>to", function()
  local ok, neotest = load_neotest()
  if ok then neotest.output.open({ enter = true }) end
end, { desc = "Open test output" })

pcall(function()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      rust = { "rustfmt" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })

  vim.keymap.set({ "n", "v" }, "<leader>cf", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, { desc = "Format buffer" })
end)

local neogit_loaded = false
local function load_neogit()
  if neogit_loaded then
    return true
  end
  for _, plugin in ipairs({ "plenary.nvim", "diffview.nvim", "neogit" }) do
    pcall(vim.cmd.packadd, plugin)
  end

  local ok_neogit, neogit = pcall(require, "neogit")
  local ok_diffview, diffview = pcall(require, "diffview")
  if not (ok_neogit and ok_diffview) then
    return false
  end

  diffview.setup({})
  neogit.setup({
    integrations = {
      diffview = true,
      fzf_lua = true,
    },
  })

  neogit_loaded = true
  return true
end

vim.keymap.set("n", "<leader>gg", function()
  if load_neogit() then vim.cmd("Neogit") end
end, { desc = "Neogit" })
vim.keymap.set("n", "<leader>gd", function()
  if load_neogit() then vim.cmd("DiffviewOpen") end
end, { desc = "Diffview open" })
vim.keymap.set("n", "<leader>gh", function()
  if load_neogit() then vim.cmd("DiffviewFileHistory %") end
end, { desc = "File history" })
vim.keymap.set("n", "<leader>gH", function()
  if load_neogit() then vim.cmd("DiffviewFileHistory") end
end, { desc = "Branch history" })
vim.keymap.set("n", "<leader>gq", function()
  if load_neogit() then vim.cmd("DiffviewClose") end
end, { desc = "Diffview close" })

-- lazygit handled by snacks.nvim

pcall(function()
  require("todo-comments").setup({})
  vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
  vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev TODO" })
  vim.keymap.set("n", "<leader>st", function()
    vim.cmd("TodoQuickFix")
    vim.cmd("copen")
  end, { desc = "Search TODOs" })
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "quarto", "rmd" },
  callback = function()
    pcall(vim.cmd.packadd, "markview.nvim")
    pcall(function()
      require("markview").setup({})
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "quarto", "rmd" },
  once = true,
  callback = function()
    local term = vim.env.TERM or ""
    local is_kitty = vim.env.KITTY_WINDOW_ID ~= nil or term:find("kitty") ~= nil
    if not is_kitty then
      return
    end

    pcall(vim.cmd.packadd, "image.nvim")
    pcall(function()
      require("image").setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            only_render_image_at_cursor = false,
          },
        },
        max_width = 100,
        max_height = 12,
        max_height_window_percentage = 50,
        max_width_window_percentage = nil,
        window_overlap_clear_enabled = false,
      })
    end)
  end,
})

-- vim-fugitive (lazy command loading)
vim.keymap.set("n", "<leader>gf", function()
  pcall(vim.cmd.packadd, "vim-fugitive")
  vim.cmd("Git")
end, { desc = "Fugitive status" })
vim.keymap.set("n", "<leader>gB", function()
  pcall(vim.cmd.packadd, "vim-fugitive")
  vim.cmd("Git blame")
end, { desc = "Git blame" })
vim.keymap.set("n", "<leader>gl", function()
  pcall(vim.cmd.packadd, "vim-fugitive")
  vim.cmd("Git log")
end, { desc = "Git log" })

-- vim-obsession (session management)
vim.keymap.set("n", "<leader>os", function()
  pcall(vim.cmd.packadd, "vim-obsession")
  vim.cmd("Obsession")
end, { desc = "Start/toggle session" })
vim.keymap.set("n", "<leader>oS", function()
  pcall(vim.cmd.packadd, "vim-obsession")
  vim.cmd("Obsession!")
end, { desc = "Stop session" })

-- vim-dispatch (async build)
vim.keymap.set("n", "<leader>md", function()
  pcall(vim.cmd.packadd, "vim-dispatch")
  vim.cmd("Dispatch")
end, { desc = "Dispatch" })
vim.keymap.set("n", "<leader>mm", function()
  pcall(vim.cmd.packadd, "vim-dispatch")
  vim.cmd("Make")
end, { desc = "Make" })
vim.keymap.set("n", "<leader>mf", function()
  pcall(vim.cmd.packadd, "vim-dispatch")
  vim.cmd("Focus")
end, { desc = "Focus (set dispatch)" })
