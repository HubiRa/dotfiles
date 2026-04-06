# nvim2

A fresh Neovim 0.12+ config for trying a more native setup.

## Goals

- use `vim.pack` instead of `lazy.nvim`
- use Neovim 0.12 LSP APIs (`vim.lsp.config()` / `vim.lsp.enable()`)
- use the new built-in `ui2`
- keep only a small set of high-value plugins

## Usage

After stowing `nvim2`, start it with:

```bash
NVIM_APPNAME=nvim2 nvim
```

This keeps it separate from your current config:

- config: `~/.config/nvim2`
- data: `~/.local/share/nvim2`
- state/cache: separate from `nvim`

## Requirements

- Neovim 0.12+
- `git`
- `ripgrep`
- `python3`
- optional: `yazi`

## Notes

- plugins are managed by `vim.pack`
- Mason is used only to install external tools, not to drive LSP wiring
- `nvim-lspconfig` supplies server configs, while Neovim core enables them
- this config intentionally uses Neovim's native statusline/diagnostics/completion stack as much as possible
