{ lib, pkgs, inputs, ...}:
{
    home.packages = with pkgs; [
        # discord
        armcord

        # video and image playback
        mpv
        imv
        stremio

        # editing images
        pinta

        # for taking notes
        obsidian
        # managing audio
        pavucontrol
        playerctl
    ];

    # adding mpv scripts
    nixpkgs.overlays = [
        (self: super: {
            mpv = super.mpv.override {
                scripts = [
                    self.mpvScripts.mpris
                    self.mpvScripts.thumbfast
                    self.mpvScripts.uosc
                ];
            };
        })
    ];
}
