{
    description = "nixos configuration flake for my main system";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        ags.url = "github:Aylur/ags";
        hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    outputs = { self, nixpkgs, ... }@inputs:
        let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
        in
    {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
                ./configuration.nix
            ];
        };
    };
}
