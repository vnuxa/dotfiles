{ ... }:
{
    # import all of the setups for various things
    imports = [
        ./browser/main.nix
        ./configuration/main.nix
        ./shell/main.nix
        ./hyprland/main.nix
        ./spotify/main.nix
        ./gaming/main.nix
        ./development/main.nix
        ./media/main.nix

        # other scripts
        ./misc/file-sharing.nix
        ./misc/packages.nix
    ];
}
