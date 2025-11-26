{
  description = "Cross-platform dev env for dotfiles";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    systems = [ "x86_64-linux" "aarch64-darwin" ];
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
            yazi
            fzf
            ripgrep
            dust
            gh
            rustc
            cargo
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
          ] ++ extraInputs;

          shellHook = ''
            export XDG_DATA_HOME=$HOME/.local/share
            export XDG_CONFIG_HOME=$HOME/.config
            export XDG_CACHE_HOME=$HOME/.cache

            # Make sure $SHELL points at nu if available
            if command -v nu >/dev/null 2>&1; then
              export SHELL=$(command -v nu)
              exec "$SHELL"
            else
              echo "nushell (nu) not found — staying in $SHELL"
            fi

            # echo "dotfiles dev shell (${system})"
            # alias v="nvim"
            # alias y="yazi"
            # if command -q zoxide
            #   eval (zoxide init fish)
            # end
          '' + extraShellHook;
        };

    devShells = forAllSystems (system: {
      default = self.lib.mkDevShell system [] "";
    });
  };
}
