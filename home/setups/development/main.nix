{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixneovim.nixosModules.default
    # import neovim configuration
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    kate

    git
    gh
    alejandra # nix code formatting
    stylua

    lua
    python3
    jq # json formatting cli, though nushell already has this

    # for setting up rust
    rust-analyzer
    rustc
    cargo
    rustfmt
    clippy
  ];

  nixpkgs.overlays = [
    inputs.nixneovim.overlays.default
  ];

  home.sessionVariables = {
    PATH = "$HOME/.local/share/nvim/mason/bin/:$PATH";
    EDITOR = "neovim";
  };
}
