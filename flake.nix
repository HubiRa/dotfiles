{
  description = "Cross-platform dev env for dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    herdr = {
      url = "github:ogulcancelik/herdr/v0.7.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, herdr }:
  let
    systems = [ "x86_64-linux" "aarch64-darwin" "aarch64-linux"];
    forAllSystems = f:
      builtins.listToAttrs (map (system: { name = system; value = f system; }) systems);
  in {
    # reusable function for other flakes
    lib.mkDevShell = system: extraInputs: extraShellHook:
      let
        pkgs = import nixpkgs { inherit system; };
      in
        pkgs.mkShell {
          buildInputs = (with pkgs; [
            stow
            neovim
            helix
            zellij
            tmux
            yazi
            fzf
            ripgrep
            dust
            gh
            rustc
            cargo
            git
            jujutsu
            lazyjj
            lazygit
            fish
            zoxide
            uv
            eza
            carapace
            starship
            rustup
            atuin
            tree-sitter
            gcc  # needed for compiling treesitter parsers
          ]) ++ [
            herdr.packages.${system}.default
          ] ++ extraInputs;

          shellHook = ''
            export XDG_DATA_HOME="$HOME/.local/share"
            export XDG_CONFIG_HOME="$HOME/.config"
            export XDG_CACHE_HOME="$HOME/.cache"

            mkdir -p "$XDG_DATA_HOME/atuin" "$XDG_CACHE_HOME"

            if command -v fish >/dev/null 2>&1; then
              export SHELL="$(command -v fish)"
            fi

            echo "dotfiles dev shell (${system})"

            # Enter fish automatically for interactive shells only.
            # Keep `nix develop -c ...` scriptable.
            case $- in
              *i*)
                if command -v fish >/dev/null 2>&1 && [ -z "''${DOTFILES_IN_FISH_SHELL-}" ]; then
                  export DOTFILES_IN_FISH_SHELL=1
                  exec fish
                fi
                ;;
            esac
          '' + extraShellHook;
        };

    devShells = forAllSystems (system: {
      default = self.lib.mkDevShell system [] "";
    });
  };
}
