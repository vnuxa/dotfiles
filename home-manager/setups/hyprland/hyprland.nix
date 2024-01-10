{ config, pkgs, lib, ...}:
{
   home.packages = [
       pkgs.hyprpicker
       pkgs.swappy
       # pkgs.libva # for wl-screenrec hardware acceleration (VAAPI)
       pkgs.wl-screenrec
       # for wallpaper colorscheme generation
       pkgs.pywal
       pkgs.swww
   ];
    
   wayland.windowManager.hyprland = {
        enable = true; # Enables Hyprland configuration
        settings = lib.mkMerge [{
            "$mod" = "SUPER"; # Setting super key
            "monitor" = ",preffered, auto, 1";


            # Input settings
            input = {
                kb_layout = "us,lt";
                kb_options = "grp:alt_shift_toggle";
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

            ] ;
            windowrule = import ./app_window_prefrences.nix ;


            # For scrolling either via mouse or the period/comma signs 
            binds = {
               workspace_back_and_forth = 0;
               allow_workspace_cycles = 1;
            };

            # Adding in common keybinds
            bind = import ./keybinds_common.nix ;

            # Extra binds
            bindir = [
              # Actions > App launcher  
              '' Super, Super_L, exec, ags run-js 'App.toggleWindow("applauncher")' ''
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
