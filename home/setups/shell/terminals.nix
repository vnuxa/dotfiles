{ config, pkgs, lib, ... }:

{
    imports = [
        ./colorschemes/kitty/hybrid.nix # import hybrid colorscheme for kitty
    ];
    home.packages = with pkgs; [
        kitty
        foot
    ];

    programs = {
        kitty = {
            enable = true;
            settings = {
                font_family = "JetBrainsMono Nerd Font";
                # bold_font = "JetBrainsMono Nerd Font Bold";
                # bold_italic_font = "JetBrainsMono Nerd Font Bold Italic";
                font_size = 12;
                shell = "${pkgs.nushell}/bin/nu";
                window_padding_width = 15;
                scrollback_lines = 10000;
                enable_audio_bell = "no";
                box_drawing_scale = "0.001, 0.05, 0.5, 1.25";
                allow_remote_control = "yes"; # for neovim
                confirm_os_window_close = 0; # remove unwelcome prompt

                background_opacity = "0.92";
                
            };
            # keybindings = {
            #     
            # };
        };

        foot = {
            enable = true;
            settings = {
                main = {
                    shell = "${pkgs.nushell}/bin/nu";
                    # shell = "/home/vnuxa/.nix-profile/bin/nu";
                    term = "xterm-256color";
                    font = "JetBrainsMono Nerd Font:size=12";

                    letter-spacing = 0;
                    dpi-aware = "no";
                    pad="15x15"; # or center
                        bold-text-in-bright="no";
                };
                scrollback = {
                    lines = 10000;
                };
                cursor = {
                    color = "282a36 f8f8f2";
                };
                colors = {
                    #catpuccin colors
                    alpha = 0.5;
                    foreground = "a9b1d6";
                    background = "1a1b26";
                    regular0 = "414868";  # black
                        regular1 = "f7768e";  # red
                        regular2 = "73daca";  # green
                        regular3 = "e0af68";  # yellow
                        regular4 = "7aa2f7";  # blue
                        regular5 = "bb9af7";  # magenta
                        regular6 = "7dcfff";  # cyan
                        regular7 = "c0caf5";  # white
                        bright0 = "414868";  # black
                        bright1 = "f7768e";  # red
                        bright2 = "73daca";  # green
                        bright3 = "e0af68";  # yellow
                        bright4 = "7aa2f7";  # blue
                        bright5 = "bb9af7";  # magenta
                        bright6 = "7dcfff";  # cyan
                        bright7 = "c0caf5";  # white
                };

                key-bindings = {
                    scrollback-up-page = "Page_Up";
                    scrollback-down-page = "Page_Down";

                    clipboard-copy = "Control+c";
                    clipboard-paste = "Control+v";
                    search-start = "Control+f";
                };

            };
        };
    };
}
