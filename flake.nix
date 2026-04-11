{
  description = "Cross-platform dev env for dotfiles";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
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
          buildInputs = with pkgs; [
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
            nushell
            zoxide
            uv
            eza
            carapace
	          starship
            rustup
            atuin
            tree-sitter
            gcc  # needed for compiling treesitter parsers
          ] ++ extraInputs;

          shellHook = ''
            export XDG_DATA_HOME="$HOME/.local/share"
            export XDG_CONFIG_HOME="$HOME/.config"
            export XDG_CACHE_HOME="$HOME/.cache"

            mkdir -p "$XDG_DATA_HOME/atuin" "$XDG_CACHE_HOME"

            if command -v nu >/dev/null 2>&1; then
              export SHELL="$(command -v nu)"
            fi

            if command -v atuin >/dev/null 2>&1 && command -v nu >/dev/null 2>&1; then
              atuin init nu > "$XDG_DATA_HOME/atuin/init.nu"
            fi

            echo "dotfiles dev shell (${system})"

            # Enter nushell automatically for interactive shells only.
            # Keep `nix develop -c ...` scriptable.
            case $- in
              *i*)
                if command -v nu >/dev/null 2>&1 && [ -z "''${PI_IN_NU_SHELL-}" ]; then
                  export PI_IN_NU_SHELL=1
                  exec nu
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
