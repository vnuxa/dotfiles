let
    pywal = builtins.fromJSON (builtins.readFile ( ./wal/colors.json ));
in{
    # Tiling layouts settings
    dwindle = {
        no_gaps_when_only = false;
        force_split = false;
        special_scale_factor = 0.8;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = "yes";
        preserve_split = "yes";
    };
    master = {
        no_gaps_when_only = false;
        new_is_master = true;
        special_scale_factor = 0.8;
    };
    
    # Decorations
    decoration = {
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;

        rounding = 5;
        blur = {
            enabled = true;
            xray = true;
            special = false;
            new_optimizations = "on";

            size = 5;
            passes = 4;
            brightness = 1;
            noise = 0.01;
            contrast = 1;
        };


        # CRT screen shader, just adds a little bit of an extra touch
        # although it might mess up text and stuff
        # screen_shader = ( builtins.toString ./crt.frag );

        dim_inactive = true;
        dim_strength = 0.15;
        dim_around = 0.2;
        "col.shadow" = "rgba(1a1a1aee)";
        "col.shadow_inactive" = "rgba(1a1a1aba)";
        shadow_range = 15;
        shadow_render_power = 3;
        # shadow_ignore_window = false;

    };
    general = {
        gaps_out = 15;
        border_size = 2;
            # an example on how to do pywal colors maybe: "col.active_border" = "0xff${colors.base0F}";
        "col.active_border" = ("rgb(" + ( builtins.replaceStrings [ "#" ] [ "" ] pywal.colors.color4) + ")" + " rgb(" + ( builtins.replaceStrings [ "#" ] [ "" ] pywal.colors.color5) + ") 90deg");
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle"; #master|dwindle
        apply_sens_to_raw=0;
    }; 

    animations = {
        enabled = "yes";

        # Animation curves
        bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "fluent_decel, 0.1, 1, 0, 1"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
        ];
        # Animation configs
        animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 2.5, md3_decel"
            # "fadeDim, 1, 2.5, md3_decel"
            "workspaces, 1, 3, linear, fade" #15%
            "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
        ];
        # For more animation settings go to https://wiki.hyprland.org/Configuring/Animations/
    };

    # Other hyprland configs
    misc = {
        disable_hyprland_logo = true;

        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        enable_swallow = true;
        focus_on_activate = true;

        vfr = true;
    };
    # bind = [
    #     '' Super,, exec, ags -t applauncher''
    # ];

    # Ags blur
    layerrule = [
        "blur, bottom-bar"
        # "ignorealpha 0.45, applauncher"

        "blur, applauncher"
        "ignorealpha 0.45, applauncher"
        "noanim, applauncher"
        "xray 0, applauncher"

        "blur, notif-window-undefined"
        "ignorealpha 0.45, notif-window-undefined"
    ];

    windowrule = [
        "opacity 0.96, discord"
        "opacity 0.96, ArmCord"
        "opacity 0.96, WebCord"
        "opacity 0.95, title:^(nvim)$"
        "opacity 0.9, libreoffice-calc"
    ];

    exec-once = [
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] armcord --enable-blind-features=MiddleClickAutoscroll"
        "[workspace 3 silent] spotify"
        "[workspace 10 silent] easyeffects"

    ];
}

