{ pkgs, lib, inputs, ... }:

{
    imports = [ inputs.spicetify-nix.homeManagerModule ];

    programs.spicetify = let
        spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
    in {
        enable = true;

        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;

        sidebarConfig = true;
        theme = spicePkgs.themes.Comfy;
        colorScheme = "rose-pine";

        enabledCustomApps = with spicePkgs.apps; [
            localFiles
            lyrics-plus
            marketplace # wont work i think (broken functionallity)
        ];

        enabledExtensions = [
            # TODO: might break idk
            spicePkgs.extensions.hidePodcasts
            spicePkgs.extensions.fullAppDisplay
            spicePkgs.extensions.shuffle # makes shuffle with 0 bias
            spicePkgs.extensions.adblock
            spicePkgs.extensions.playlistIcons
            # lastfm
            spicePkgs.extensions.historyShortcut
            spicePkgs.extensions.bookmark
            spicePkgs.extensions.fullAlbumDate
            # groupSession
            # powerBar
            # wikify
            spicePkgs.extensions.copyToClipboard
            spicePkgs.extensions.autoVolume

            (
                let
                    dummy = builtins.toFile "dummy.js" "";
                in { 
                    src = builtins.dirOf dummy;
                    filename = builtins.baseNameOf dummy;
                    experimentalFeatures = true;
                }
            )
        ];
    };
}


