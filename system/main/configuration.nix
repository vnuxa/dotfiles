{
  inputs,
  config,
  pkgs,
  ...
}: let
  # for setting up the greeter for greetd (which will use ags)
  greeter = pkgs.stdenv.mkDerivation {
    name = "greeter";
    src = ./greeter;
    installPhase = ''
      mkdir -p $out
      mv * $out
    '';
  };
  # hyprland configuration for my greeter
  conf = pkgs.writeText "config" ''
    exec-once = ags --config ${greeter}/greeter.js; hyprctl dispatch exit
    exec-once = swww init
    exec-once = foot swww img ${greeter}/wallpapers/lockscreen1.png

    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        force_default_wallpaper = 0
    }
  '';
in {
  # importing hardware scan results
  imports = [
    ./hardware-configuration.nix
  ];

  # bootloader
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      gfxmodeEfi = "1920x1080";
    };
  };

  # network stuff
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # locale
  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";

  # nvidia video drivers for x11 and wayland
  services.xserver.videoDrivers = ["nvidia"];
  boot.initrd.kernelModules = ["nvidia"];

  # enable x11 windowing system (i think for xwayland??)
  services.xserver.enable = true;
  services.xserver.libinput.mouse.accelProfile = "flat"; # fix mouse acceleration
  # configure x11 keymap
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # wayland-related stuff
  # using hyprland as window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  # include some variable patches
  environment.sessionVariables = {
    # if the cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    PKG_CONFIG_PATH = "${pkgs.libxkbcommon.dev}/lib/pkgconfig";
    # telling electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    # hyprland nvidia fix
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    FLAKE = "/etc/nixos#default";
  };

  hardware = {
    opengl = {
      enable = true;
      # driSupport = true;
      # driSupport32Bit = true;
      # TODO: might have to delete nvidia stuff later?
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    nvidia = {
      modesetting.enable = true;
      # use latest stable nvidia drivers
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      # use nvidia open source kernel module (not to be confused with novoeu)
      open = true; # leave enabled
      # add the command nvidia-settings
      nvidiaSettings = true;
      # experimental nvidia power management
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };
  };

  boot.blacklistedKernelModules = ["nouveau"];

  boot.kernelParams = [
    "split_lock_detect=off" # in order to make unoptimized apps run better
    "module_blacklist=i915"
  ];

  # hyprland desktop portals
  xdg.portal.enable = true;
  xdg.autostart.enable = true;

  # use greetd as greeter
  services.greetd = {
    enable = true;
    settings.default_session.command = "Hyprland --config ${conf}";
  };

  # enable sound via pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # to use jack applications, uncomment
    # jack.enable = true;
  };

  # enable some "experimental" nixos features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.dconf.enable = true;

  # for logitech mouse configuration
  services.ratbagd.enable = true;

  # garbage collection
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # optimize packages by hardlinking store files
    optimise = {
      automatic = true;
    };
  };

  # user account related stuff
  programs.adb.enable = true;

  users.users.vnuxa = {
    isNormalUser = true;
    description = "vnuxa";
    extraGroups = ["network" "wheel" "adbusers"];
  };

  # packaging
  services.flatpak.enable = true;
  nixpkgs.config.allowUnfree = true;
  # latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    home-manager # for configs
    nh # helper for nix commands
    inputs.ags.packages.${pkgs.system}.ags

    # for astrum ( TEMPORARY, i think?)
    libxkbcommon
    # for hyprland
    swww

    # terminal stuff
    fish
    kitty
    starship

    # for mounting
    ntfs3g
    exfat

    # authentication
    gnome.gnome-keyring
    polkit_gnome

    # network
    networkmanagerapplet

    # misc
    bc
    killall

    # vulkan graphics
    vulkan-loader
    vulkan-tools

    # nvidia hardware accel
    vaapiVdpau
    libvdpau-va-gl
    libva-utils
    nvidia-vaapi-driver
    # vulkan stuff
    vulkan-loader
    vulkan-tools
  ];

  # setting fish as default shell
  programs.fish.enable = true;
  users.users.vnuxa.shell = pkgs.fish;

  # authentication stuff
  services.gnome.gnome-keyring.enable = true;

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        execStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  system.stateVersion = "23.11"; # might have to change this when swithcing pcs
}
