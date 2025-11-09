{
  description = "Cross-platform dev env for dotfiles";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    systems = [ "x86_64-linux" "aarch64-darwin" ];
    forAllSystems = f:
      builtins.listToAttrs (map (system: { name = system; value = f system; }) systems);
  in {
    devShells = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            stow
            neovim
            helix
            zellij
            yazi
            fzf
            ripgrep
            du-dust
            gh
            gitui
            rustc
            cargo
          ];

          shellHook = ''
            echo "dotfiles dev shell (${system})"
            echo "Tools available: nvim, hx, zellij, yazi, fzf, rg, dust, gh, gitui, stow"
            alias v="nvim"
            alias y="yazi"
          '';
        };
      });
  };
}
