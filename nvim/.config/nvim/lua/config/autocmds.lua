local general = vim.api.nvim_create_augroup("nvim-general", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = general,
  callback = function(ev)
    local buf_name = vim.api.nvim_buf_get_name(ev.buf)
    local is_special = buf_name:match("yazi") or buf_name:match("lazygit") or buf_name:match("fzf")

    vim.bo[ev.buf].buflisted = false
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"

    -- Only for regular terminals
    if not is_special then
      vim.bo[ev.buf].filetype = "terminal"
      vim.cmd.startinsert()

      -- Auto-run nix develop if flake.nix exists
      if vim.fn.filereadable("flake.nix") == 1 then
        vim.defer_fn(function()
          local chan = vim.b[ev.buf].terminal_job_id
          if chan then
            vim.fn.chansend(chan, "nix develop\n")
          end
        end, 100)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = general,
  pattern = "term://*",
  callback = function()
    vim.cmd.startinsert()
  end,
})
