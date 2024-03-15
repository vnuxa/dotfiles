{ pkgs, lib, spicetify-nix, ... }:

{
  imports = [ spicetify-nix.homeManagerModule ];

  programs.spicetify = let
    spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
  in {
    enable = true;

    # injectCss = true;
    # replaceColors = true;
    # overwriteAssets = true;

    # sidebarConfig = true;
    theme = spicePkgs.themes.Comfy;
    colorScheme = "rose-pine";

    enabledCustomApps = with spicePkgs.apps; [
      localFiles
      lyrics-plus
      marketplace # wont work i think (broken functionallity)
      new-releases # shows new releases from the artist you follow
    ];

    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts
      # shuffle # makes shuffle with 0 bias
      adblock
      playlistIcons
      # lastfm
      historyShortcut
      bookmark
      fullAlbumDate
      # groupSession
      # powerBar
      # wikify
      copyToClipboard
    ];
  };
}
