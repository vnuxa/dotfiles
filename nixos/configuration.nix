# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:
let
    ags = inputs.ags.packages.${pkgs.system}.ags;
    greeter = pkgs.stdenv.mkDerivation {
        name = "greeter";
        src = ./greeter;
        installPhase = ''
            mkdir -p $out
            mv * $out
        '';
    };
    # exec-once = swww init #TODO: add swww to the line bellow, not doing it rn cuz i cant find a wallpaper to use
    #FIXME: make it so that hyprland will not autogenerate the wallpapers

# exec-once = swww init
# exec-once = swww img ${ greeter }/wallpapers/lockscreen1.png
        # bind= SHIFTSUPER, W, exec, foot swww img ${ greeter }/wallpapers/lockscreen1.png
        #
        # bind=SUPER, Grave, exec, foot --override shell=fish
        # bind= CONTROLSUPER, R, exec, pkill ags
        # bind= SHIFTSUPER, R, exec, ags --config ${ greeter}/greeter.js
        # bind= CONTROLSUPER, E, exec, hyprctl dispatch exit
        # bind= SHIFTSUPER, T, exec, foot ags --config ${ greeter }/greeter.js 
    conf = pkgs.writeText "config" ''
        exec-once = ags --config ${ greeter }/greeter.js; hyprctl dispatch exit
        exec-once = swww init
        exec-once = foot swww img ${ greeter }/wallpapers/lockscreen1.png


        misc {
            disable_hyprland_logo = true
            disable_splash_rendering = true
            force_default_wallpaper = 0
        }

    '';

in
{
  #? Important system stuff
  imports = [ # Include the results of the hardware scan.
  ./hardware-configuration.nix #inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader.
  boot.loader = {
    grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
        gfxmodeEfi = "1920x1080";
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # action Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

# Add nvidia video drivers for both X11 and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  boot.initrd.kernelModules = [ "nvidia" ];

  # Enable the X11 windowing system.

  services.xserver.enable = true;
  services.xserver.libinput.mouse.accelProfile = "flat";


  # use wayland
  # services.xserver.displayManager.defaultSession = "plasmawayland";
  #? Using hyprland as the window manager
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # If the cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Tell electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    # Hyprland nvidia fix
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  hardware = {
    # OpenGL
    opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
            rocm-opencl-icd
            rocm-opencl-runtime
            vaapiVdpau
            libvdpau-va-gl
        ];
    };

    # most wayland compositors need this
    nvidia = {
        modesetting.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        # Use nvidia open source kernel module (not to be confused with the Novoeu driver)
        open = true; # Dont disable unless theres a good reason (unsupported hardware)
        # Add nvidia-settings menu (accesible by running nvidia-settings)
        nvidiaSettings = true;
        # Experimental nvidia power management, can cause sleep/suspend to fail
        powerManagement.enable = false;
        powerManagement.finegrained = false; #Fine-grained power management, turns off GPU when not in use
    };
    
  };
  boot.blacklistedKernelModules = [ "nouveau" ];

    boot.kernelParams = [
      "split_lock_detect=off" # In order to fix vinegar's optimization issues  
      "module_blacklist=i915"
    ];

  #? hyprland desktop portals
  xdg.portal.enable = true;
  xdg.autostart.enable = true; #maybe fixes things idk
 # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk];
  # xdg.portal.config.common.default = "hyprland";

  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  services.greetd = {
      enable = true;
      settings.default_session.command = "Hyprland --config ${conf}";
  };
  # services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  #? settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  # hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses

  programs.dconf.enable = true;

    services.ratbagd.enable = true; # For logitech mouse configuraiton
  
  #? garbage collection
  nix.gc = { # Automatic Garbage Collection
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  #? packages
  # get flapak packages 
  services.flatpak.enable = true;
  # might need dbus??
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ]; #TODO outdated
  # xdg.portal.config.common.default = "kde"; #TODO outdated
  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.adb.enable = true;
  users.users.vnuxa = {
    isNormalUser = true;
    description = "vnuxa";
    extraGroups = [ "networkmanager" "wheel" "adbusers"];
    packages = with pkgs; [
      # firefox
      # kate

      # # communication
      # webcord-vencord

      # # editing
      # vscodium

      # # audio
      # spicetify-cli
      # spotify
    #  thunderbird
    ];
  };
  # get the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager # for configs
    inputs.ags.packages.${pkgs.system}.ags
    inputs.hyprland.packages.${pkgs.system}.hyprland
    
    #? for hyprland
    # waybar #TODO remove this temporary file with ags
    swww # wallpapers on hyprland
    #* theres mpvpaper (might work with moving images); wpaperd; swww; swaybg 
    # browsers
    floorp

    # document editing
    libreoffice
    
    # file explorer
    cinnamon.nemo

    # task manager
    # mission-center
    
    # fish shell
    fish
    foot # wayland terminal
    kitty
    starship

    # for mounting
    ntfs3g
    exfat
    # note taking
    # obsidian #! add it back as a home-manager thing
    #? for hyprland
      #clipboard
      wl-clipboard
      cliphist
      # screenshots
      grim
      slurp
      # recording
      libva
      libva-utils
      wf-recorder
      # color picking
      
      # a launcher for things (like clipboard, applications)
      fuzzel
      # notifications
      libnotify
    # media
    playerctl
    
    # audio control
    pavucontrol

    #authentication
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
    # laptop battery
 #   upower
  ];
  # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
  # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
  
  # environment.sessionVariables = rec {
  #   PATH="$HOME/.local/share/nvim/mason/bin/:$PATH";
  # };
  programs.fish.enable = true;
  users.users.vnuxa.shell = pkgs.fish;
  services.gnome.gnome-keyring.enable = true;
  
  # for battery
#  services.upower.enable = true;

systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  };
};

#configuring libva
#might need to somehow get vaapi stuff idk

  #   environment.etc = {
  #   "xdg/gtk-3.0".source =  ./gtk-3.0;
  #   "xdg/gtk-4.0".source =  ./gtk-4.0;
  # };


  #? Home manager
  # * To rebuild home manager use this commnad
  # * home-manager switch

  #* Home manager is located in ~/.config/home-manager/
  # home-manager = {
  #   extraSpecialArgs = { inherit inputs; };
  #   users = {
  #     vnuxa = import ./home.nix;
  #   };
  # };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
# * To rebuild nixos, use this command
#* sudo nixos-rebuild switch
