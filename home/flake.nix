{
    description = "home manager configuration";

    inputs = {
        # Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            # inputs.nixpkgs.follows = "nixpkgs";
            # create an input called spicetify-nix, and set its url to this repository
        };
        # Gaming Tools
        nix-gaming = {
            url = "github:fufexan/nix-gaming";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        #Spicetify 
        spicetify-nix = { 
            url = "github:the-argus/spicetify-nix"; 
            inputs.nixpkgs.follows = "nixpkgs"; 
        };
        # extensions for firefox
        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # ags for hyprland
        ags.url = "github:Aylur/ags";
        nixneovim.url = "github:nixneovim/nixneovim";

        #for building rust packages with ease
        # https://github.com/nix-community/naersk 
        # naersk-nix.url = "github:nix-community/naersk";
    };
    # TODO: there might be a possibler bug with this
    outputs = { self, nixpkgs, home-manager, ... }@inputs:
        let
            pkgs = import nixpkgs { system = "x86_64-linux"; };

            specialArgs = { inherit inputs; };
        in {
            homeConfigurations."vnuxa" = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;

                extraSpecialArgs = specialArgs;
                modules = [
                    ./home.nix
                ];
            };
        };
}
