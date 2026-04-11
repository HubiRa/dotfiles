# nvim

Neovim 0.12+ config using core APIs and `vim.pack`.

## Goals

- use `vim.pack` instead of `lazy.nvim`
- use Neovim 0.12 LSP APIs (`vim.lsp.config()` / `vim.lsp.enable()`)
- keep the config relatively small and native-first

## Usage

This package is intended to be stowed as `nvim/`, which creates:

- config: `~/.config/nvim`
- data: `~/.local/share/nvim`
- state/cache: standard `nvim` paths

Typical setup from the repo root:

```bash
./install.sh
nix develop
nvim
```

If you want Nushell explicitly inside the dev shell:

```bash
nix develop -c nu
```

## Requirements

- Neovim 0.12+
- `git`
- `ripgrep`
- `python3`
- optional: `yazi`, `lazygit`, `debugpy`

## Notes

- plugins are managed by `vim.pack`
- plugin revisions are pinned in `nvim/.config/nvim/nvim-pack-lock.json`
- `nvim-lspconfig` supplies server configs, while Neovim core enables them
- Mason is available for manual tool installation; use `:Mason` or `:MasonInstallCore`
- the surrounding shell/tool environment is provided by `flake.nix`
