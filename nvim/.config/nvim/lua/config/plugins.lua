local ok, mason = pcall(require, "mason")
if ok then
  mason.setup({
    ui = {
      border = "rounded",
    },
  })

  local ok_registry, registry = pcall(require, "mason-registry")
  if ok_registry then
    registry.refresh(function()
      for _, name in ipairs({
        "lua-language-server",
        "stylua",
        "pyright",
        "ruff",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "yaml-language-server",
        "bash-language-server",
        "marksman",
        "debugpy",
      }) do
        local ok_pkg, pkg = pcall(registry.get_package, name)
        if ok_pkg and not pkg:is_installed() then
          pkg:install()
        end
      end
    end)
  end
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
  local ts_install = require("nvim-treesitter.install")
  ts_install.ensure_installed({
    "bash", "c", "css", "dockerfile", "go", "html", "javascript",
    "json", "lua", "markdown", "markdown_inline", "nix", "python",
    "query", "regex", "rust", "toml", "tsx", "typescript", "vim",
    "vimdoc", "yaml",
  })
end)

-- Enable treesitter highlighting for all buffers (Neovim 0.12+ native)
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
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
            -- Go back to original window
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
  -- Basic fzf keymaps (snacks handles most LazyVim-style ones)
  vim.keymap.set("n", "<leader>ff", pick_file_in_current_win(fzf.files, { query = "" }), { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
end)

pcall(function()
  local snacks = require("snacks")
  snacks.setup({
    -- LazyVim-style features
    bigfile = { enabled = true },
    dashboard = { enabled = false }, -- requires lazy.nvim
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scratch = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    -- Picker (uses fzf-lua style)
    picker = { enabled = true },
    -- Terminal
    terminal = { enabled = true },
    -- Git integration
    lazygit = { enabled = true },
    -- Smooth scrolling
    scroll = { enabled = false },
    -- Zen mode
    zen = { enabled = true },
    -- Buffer management
    bufdelete = { enabled = true },
    -- Toggle features
    toggle = { enabled = true },
  })

  -- Snacks keymaps (LazyVim style)
  local map = vim.keymap.set

  -- Helper: open file in current window even if terminal
  local function snacks_pick_in_win(picker_fn, opts)
    return function()
      local win = vim.api.nvim_get_current_win()
      picker_fn(vim.tbl_extend("force", opts or {}, {
        confirm = function(picker, item)
          picker:close()
          if item and item.file then
            vim.api.nvim_set_current_win(win)
            if vim.bo.buftype == "terminal" then
              vim.cmd("enew")
            end
            vim.cmd("edit " .. vim.fn.fnameescape(item.file))
          end
        end,
      }))
    end
  end

  -- Top-level shortcuts
  map("n", "<leader><space>", snacks_pick_in_win(snacks.picker.files), { desc = "Find files" })
  map("n", "<leader>,", function() snacks.picker.buffers() end, { desc = "Switch buffer" })
  map("n", "<leader>/", function() snacks.picker.grep() end, { desc = "Grep" })
  map("n", "<leader>:", function() snacks.picker.command_history() end, { desc = "Command history" })
  map("n", "<leader>.", function() snacks.scratch() end, { desc = "Scratch buffer" })

  -- Find
  map("n", "<leader>fr", snacks_pick_in_win(snacks.picker.recent), { desc = "Recent files" })
  map("n", "<leader>fc", function() snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find config file" })

  -- Search
  map("n", "<leader>sa", function() snacks.picker.autocmds() end, { desc = "Autocmds" })
  map("n", "<leader>sb", function() snacks.picker.lines() end, { desc = "Buffer lines" })
  map("n", "<leader>sc", function() snacks.picker.commands() end, { desc = "Commands" })
  map("n", "<leader>sd", function() snacks.picker.diagnostics() end, { desc = "Diagnostics" })
  map("n", "<leader>sh", function() snacks.picker.help() end, { desc = "Help" })
  map("n", "<leader>sk", function() snacks.picker.keymaps() end, { desc = "Keymaps" })
  map("n", "<leader>sm", function() snacks.picker.marks() end, { desc = "Marks" })
  map("n", "<leader>sr", function() snacks.picker.registers() end, { desc = "Registers" })
  map("n", "<leader>ss", function() snacks.picker.lsp_symbols() end, { desc = "LSP symbols" })
  map("n", "<leader>sw", function() snacks.picker.grep_word() end, { desc = "Grep word" })

  -- Git
  map("n", "<leader>gc", function() snacks.picker.git_log() end, { desc = "Git commits" })
  map("n", "<leader>gs", function() snacks.picker.git_status() end, { desc = "Git status" })
  map("n", "<leader>lg", function() snacks.lazygit() end, { desc = "LazyGit" })

  -- Buffers
  map("n", "<leader>bd", function() snacks.bufdelete() end, { desc = "Delete buffer" })
  map("n", "<leader>bD", function() snacks.bufdelete.all() end, { desc = "Delete all buffers" })

  -- UI toggles
  map("n", "<leader>uz", function() snacks.zen() end, { desc = "Zen mode" })
  map("n", "<leader>un", function() snacks.notifier.hide() end, { desc = "Dismiss notifications" })

  -- Terminal
  map("n", "<leader>tt", function() snacks.terminal() end, { desc = "Toggle terminal" })
  map("n", "<c-/>", function() snacks.terminal() end, { desc = "Toggle terminal" })

  -- Misc
  map("n", "<leader>.", function() snacks.scratch() end, { desc = "Scratch buffer" })
  map("n", "<leader>n", function() snacks.notifier.show_history() end, { desc = "Notification history" })

  -- Navigation (] and [ style)
  map("n", "]]", function() snacks.words.jump(1) end, { desc = "Next reference" })
  map("n", "[[", function() snacks.words.jump(-1) end, { desc = "Prev reference" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>bprev<cr>", { desc = "Prev buffer" })
  map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

  -- Save/Quit
  map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
  map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
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

pcall(function()
  local dap = require("dap")
  local dapui = require("dapui")

  dapui.setup()
  require("dap-python").setup("python3")

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

  vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
  vim.keymap.set("n", "<leader>dB", dap.set_breakpoint, { desc = "Set conditional breakpoint" })
  vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
  vim.keymap.set("n", "<leader>ds", dap.step_into, { desc = "Step into" })
  vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Step over" })
end)

pcall(function()
  require("neotest").setup({
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
      }),
    },
  })

  vim.keymap.set("n", "<leader>tt", function()
    require("neotest").run.run()
  end, { desc = "Run nearest test" })
  vim.keymap.set("n", "<leader>tf", function()
    require("neotest").run.run(vim.fn.expand("%"))
  end, { desc = "Run file tests" })
  vim.keymap.set("n", "<leader>ts", function()
    require("neotest").summary.toggle()
  end, { desc = "Toggle test summary" })
  vim.keymap.set("n", "<leader>to", function()
    require("neotest").output.open({ enter = true })
  end, { desc = "Open test output" })
end)

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

pcall(function()
  require("neogit").setup({
    integrations = {
      diffview = true,
      fzf_lua = true,
    },
  })

  vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
end)

pcall(function()
  require("diffview").setup({})

  vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
  vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
  vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Branch history" })
  vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
end)

-- lazygit handled by snacks.nvim

pcall(function()
  require("todo-comments").setup({})
  vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
  vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev TODO" })
  vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })
end)

pcall(function()
  require("zen-mode").setup({
    window = {
      backdrop = 0.95,
      width = 0.6,
    },
  })
  vim.keymap.set("n", "<leader>zz", "<cmd>ZenMode<cr>", { desc = "Zen mode" })
end)

pcall(function()
  require("markview").setup({})
end)

pcall(function()
  require("image").setup({
    backend = "kitty", -- or "ueberzug" for X11
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

-- vim-fugitive (no setup needed, just keymaps)
vim.keymap.set("n", "<leader>gf", "<cmd>Git<cr>", { desc = "Fugitive status" })
vim.keymap.set("n", "<leader>gB", "<cmd>Git blame<cr>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>gl", "<cmd>Git log<cr>", { desc = "Git log" })

-- vim-obsession (session management)
vim.keymap.set("n", "<leader>os", "<cmd>Obsession<cr>", { desc = "Start/toggle session" })
vim.keymap.set("n", "<leader>oS", "<cmd>Obsession!<cr>", { desc = "Stop session" })

-- vim-dispatch (async build)
vim.keymap.set("n", "<leader>md", "<cmd>Dispatch<cr>", { desc = "Dispatch" })
vim.keymap.set("n", "<leader>mm", "<cmd>Make<cr>", { desc = "Make" })
vim.keymap.set("n", "<leader>mf", "<cmd>Focus<cr>", { desc = "Focus (set dispatch)" })
