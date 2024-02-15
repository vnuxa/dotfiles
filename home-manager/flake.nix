{
  description = "Home Manager configuration of vnuxa";

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
    # ags for hyprland
    ags.url = "github:Aylur/ags";
    nixneovim.url = "github:nixneovim/nixneovim";
  };


    # the ... lets us accept any inputs, and "@ inputs" lets us capture those.
  outputs = {
    self,
    nixpkgs, 
    home-manager, 
    # setups  
    nix-gaming, 
    spicetify-nix,
    # modules
    ags,
    nixneovim,
    ...
  } @ inputs: let     
    # here we use nixpkgs from our inputs, which is why why included it
    # above instead of just {...} @ inputs. If we did that, this would be
    # "inputs.nixpkgs".
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    specialArgs = { #? put setups here too
      inherit nix-gaming;
      inherit spicetify-nix;
      # modules
      inherit ags;
      inherit nixneovim;
    };
  in {
    homeConfigurations."vnuxa" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      # put our flake inputs into the "inputs" argument of extraSpecialArgs.
      extraSpecialArgs = specialArgs;
      modules = [
          ./home.nix
          # ./spicetify.nix # file where you configure spicetify
      ];
    };
  };

}

# * see home.nix on how to apply changes!
