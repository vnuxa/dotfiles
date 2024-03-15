{
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

        rounding = 10;
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

        drop_shadow = true;
        shadow_range = 35;
        shadow_render_power = 3;
        shadow_ignore_window = false;

        #screen_shader = "~/Documents/Programming/hyprshaders/crt.frag";

        dim_inactive = false;
        "col.shadow" = "rgba(1a1a1aee)";
    };
    general = {
        gaps_in = 5;
        gaps_out = 22;
        border_size = 2;
            # an example on how to do pywal colors maybe: "col.active_border" = "0xff${colors.base0F}";
        "col.active_border" = "rgba(ffffffac) rgba(db93ffac) 90deg"; #TODO: Make pywal automatically change the 1st and 2nd variable (rn 1st is white and 2n is pinkish)
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

    # Ags blur
    layerrule = [
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
        "[workspace 1 silent] floorp"
        "[workspace 2 silent] armcord --enable-blind-features=MiddleClickAutoscroll"
        "[workspace 3 silent] spotify"
        "[workspace 10 silent] easyeffects"

    ];
}
