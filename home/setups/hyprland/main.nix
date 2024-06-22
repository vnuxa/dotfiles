{ inputs, config, pkgs, lib,...}:
{
    imports = [
        inputs.ags.homeManagerModules.default # importing ags
    ];
    home.packages = with pkgs; [
        hyprpicker
        swappy
        grimblast # screenshotting tool
        grim
        slurp
        #clipboard stuff
        wl-clipboard
        cliphist
        # pkgs.libva # for wl-screenrec hardware acceleration (VAAPI)
        wl-screenrec
        # for wallpaper colorscheme generation
        pywal
        swww
        # recording
        wf-recorder

        # ags dependencies
        gvfs # cover art caching (mpris)
        libdbusmenu-gtk3 # for system tray
        sassc
    ];

    # home.file.".config/ags/node_modules".source = pkgs.fetchNpmDeps {
    #     src = (./. + ("/dots/" + config.theme.hyprland.dot-name + "/ags/package-lock.json"));
    #     # add hash
    # };

    programs.ags = {
        enable = true;
        extraPackages = [ pkgs.libsoup_3 ];
        configDir = (./. + ("/dots/" + config.theme.hyprland.dot-name + "/ags"));
    };

    # home

    wayland.windowManager.hyprland = {
        enable = true; # Enables Hyprland configuration
            settings = lib.mkMerge [{
                "$mod" = "SUPER"; # Setting super key
                    "monitor" = ",highrr, auto, 1";
                general = {
                    allow_tearing = true;
                };
                env = [
                    "WLR_DRM_NO_ATOMIC, 1"
                ];
                windowrulev2 = [
                    "immediate, class:^(Minecraft* 1.16.5)$"
                ];


                # Input settings
                input = {
                    kb_layout = "us,lt";
                    kb_options = "grp:alt_shift_toggle, caps:escape";
                    follow_mouse = 2;
                    float_switch_override_focus = 2;
                    touchpad.natural_scroll = "no"; 
                    sensitivity = 0;
                };

                # Touchpad gestures
                gestures = {
                    workspace_swipe = true;
                    workspace_swipe_fingers = 3;
                    workspace_swipe_distance = 250;
                    workspace_swipe_invert = true;
                    workspace_swipe_min_speed_to_force = 15;
                    workspace_swipe_cancel_ratio = 0.5;
                    workspace_swipe_create_new = false;
                };

                # For opening apps and such
                exec-once = [
                    "ags &"
                        "nm-applet --indicator &" # network manager (for internet)
                        "swww init" # wallpapers
                        "wl-paste --primary --watch wl-copy --primary --clear" # removes middle mouse paste, for autoscrolling
                        "~/wallpaper_script.sh"
                        "~/color_gen.sh"

                ] ;
                windowrule = import ./app_window_prefrences.nix ;


                # For scrolling either via mouse or the period/comma signs 
                binds = {
                    workspace_back_and_forth = 0;
                    allow_workspace_cycles = 1;
                };

                # Adding in common keybinds
                bind = import ./keybinds_common.nix;

                # Extra binds
                bindir = [
                    # Actions > App launcher  
                    # '' Super, Super_L, exec, ags run-js 'App.toggleWindow("applauncher")' ''
                    '' Super, Super_L, exec, ags -t applauncher''
                ];

                bindle = [
                    # Controls > Audio controls 
                    ", XF86AudioRaiseVolume, exec, playerctl volume $(echo \"$(playerctl volume) + 0.025\" | bc) " #! broken, need fixing
                        ", XF86AudioLowerVolume, exec, playerctl volume $(echo \"$(playerctl volume) - 0.025\" | bc) "

                ];

                bindm = [
                    # Hyprland > Mouse controls
                    "SUPER, mouse:272, movewindow"
                        "SUPER, mouse:273, resizewindow"
                        "SUPER, Z, movewindow"
                ];

            # Adding in the custom theme settings
            
            } (import (./. + ("/dots/" + config.theme.hyprland.dot-name + "/main.nix"))) ];

    };

}
