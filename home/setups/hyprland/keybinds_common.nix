#INFO:
# $mod refers to super key
[
    #INFO: Apps
    # Opening apps

    "$mod, W, exec, firefox --private-window"
    "$mod, E, exec, nemo"
    "$mod, C, exec, kitty --hold nu -c 'kitten @ set-spacing padding=0 | nvim' | from nuon" # run kitty with no padding with neovim
    "$mod, Grave, exec, kitty"

    # Interracting with apps

    "$mod, Q, killactive"
    "$mod, X, exec, gnome-text-editor --new-window --ignore-session"
    "$mod, F, fullscreen"
    "$mod ALT, F, fakefullscreen"
    "$mod, Y, pin"
    "$mod, J, togglesplit" #for dwindle layout

    "$mod, K, togglegroup"
    "$mod CTRL, Tab, changegroupactive, f"


    # Opening app settings and configuration UI's'

    "CONTROLSUPER, V, exec, pavucontrol" # audio control
    "CONTROLSHIFT, Escape, exec, missioncenter" # mission center ( task manager-like )
    "CONTROLALTSHIFT, Escape, exec, foot -T 'btop' btop" #TODO: opens btop, might need to replace with htop 

    #INFO: Actions
    # Applauncher / overview
    # IN hyprland.nix, due to the fact that it requires build flags

    # screenshots
    "SUPERSHIFT, D, exec, ~/.local/bin/rubyshot | wl-copy" # unsure if it works
    ''SUPERSHIFT, S, exec, grim -g "$(slurp)" - | swappy -f -''

    # recording
    "SUPERSHIFT, R, exec, ~/.local/bin/record-script.sh"
    "CONTROLALT, R, exec, ~/.local/bin/record-script.sh --sound"
    "SUPERSHIFTALT, R, exec, ~/.local/bin/record-script-fullscreen.sh"
    #TODO: Add wl-screenrec support for nvidia-shadowplay like recording

    # color picker
    "SUPERSHIFT, C, exec, hyprpicker -a" #FIXME: this is broken due to a SIGSENV error

    #TODO: Clipboard manager

    #INFO: Controls
    # Media controls
    "SUPERSHIFT, N, exec, playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100 \"` "
    "SUPERSHIFT, B, exec, playerctl previous"
    "SUPERSHIFT, P, exec, playerctl play-pause"

    # For audio controls
    ", XF86AudioMute,exec,amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPrev, exec, playerctl previous"
    # More is in hyprland.nix
    
    # Other controls
    "$mod SHIFT, M, exit" # logs out computer
    "$mod, TAB, togglefloating"

    # manually restart ags colorscheme. it doesnt automatically do it after rebuild
    "$mod ALT, R, exec, ~/wallpaper_script.sh; ~/color_gen.sh; pkill ags; ags &"
    #TODO: Lock screens

    #INFO: AGS related
    # Reload ags
    "$mod CTRL, R, exec, hyprctl reload; pkill ags; ags &"

    # Notification test
    "SUPERALT, f11, exec, notify-send \"Test notification 2\" \"this is shorter and cooler\" "


    #INFO: Hyprland keybinds 
    # Move focus by Super + Arrow keys
    "$mod, left, movefocus, l"
    "$mod, right, movefocus, r"
    "$mod, up, movefocus, u"
    "$mod, down, movefocus, d"

    # Workspace switching (moslty managed in hyprland.nix)
    "$mod, period, workspace, e+1"
    "$mod, comma, workspace, e-1"

    "ALT, Tab, cyclenext"
    "ALT, Tab, bringactivetotop" # so it gets focused

    "$mod, minus, movetoworkspace, special"
    "$mod, equal, togglespecialworkspace"

    "$mod SHIFT, left, movewindow, l"
    "$mod SHIFT, right, movewindow, r"
    "$mod SHIFT, up, movewindow, u"
    "$mod SHIFT, down, movewindow, d"

    "CTRL, left, movetoworkspace, -1"
    "CTRL, right, movetoworkspace, +1"

    # Be able to scroll through existing workspaces
    "SUPER, mouse_up, workspace, +1"
    "SUPER, mouse_down, workspace, -1"
    "CONTROLSUPER, mouse_up, movetoworkspace, +1"
    "CONTROLSUPER, mouse_down, movetoworkspace, -1"

    


    

    
]
++ (
# adds workspaces switching (without the need to copy it over 10x)
# binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
                x: let
                ws = let
                c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
                in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "CTRL, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
                ]
                )
            10)
   )
