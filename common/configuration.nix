# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.kernelParams = ["preempt=full"];
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  fonts.packages = with pkgs; [
    font-awesome
    fira-code
    nerd-fonts._0xproto
  ];

  programs.kdeconnect.enable = true;

  security.polkit.enable = true;
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
  };

  services.logmein-hamachi.enable = true;

  #Environment Variables
  environment.sessionVariables = rec {
    NIXPKGS_ALLOW_UNFREE="1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1.5";
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.libglvnd
      pkgs.pulseaudio
    ];
  };

  #Allow UNFREE
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  boot.supportedFilesystems = [ "ntfs" ];
  programs.adb.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk # Often a good fallback for GTK apps
    ];
    xdgOpenUsePortal = true;
  };
  programs.nix-ld.enable = true;
  programs.noisetorch.enable = true;
  programs.nix-ld.libraries = pkgs.steam-run.args.multiPkgs pkgs;

  xdg.terminal-exec.enable = true;
  xdg.terminal-exec.settings = {
    default = ["ghostty.desktop"];
  };

  virtualisation.docker= {
    enable = true;
  };

  users.extraGroups.docker.members = ["nixuser"];
  programs.thunar.enable = true;
  services.tumbler.enable = true; # Thumbnail support for images
 # services.ollama = {
 #   enable = true;
 #   acceleration = "rocm";
 #   environmentVariables = {
 #     OLLAMA_DEBUG="1";
 #     OLLAMA_GPU_OVERHEAD = "20GB";
 #     #HCC_AMDGPU_TARGET = "gfx1031"; # used to be necessary, but doesn't seem to anymore
 #   };
 #   rocmOverrideGfx = "10.3.1";
 # };

  #Automounting with nautilus
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  #syncthing
  services.syncthing.enable = true;
  #Enable flatpak
  services.flatpak.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      experimental = true; # show battery

      # https://www.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax/
      # for pairing bluetooth controller
      Privacy = "device";
      JustWorksRepairing = "always";
      Class = "0x000100";
      FastConnectable = true;
    };
  };

  hardware.xpadneo.enable = true; # Enable the xpadneo driver for Xbox One wireless controllers

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ xpadneo ddcci-driver];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    '';
    # connect xbox controller
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
    #useXkbConfig = true; # use xkb.options in tty.
  };

  #Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  programs.hyprland.enable = true; # enable Hyprland
  programs.hyprland.withUWSM = true;
  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sound.  
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    extraConfig.pipewire = {
      "clock-rate-config" = {
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 8192;
      };
      #"context.properties" = {
      #  "default.clock.rate" = 95999;
      #  "default.clock.allowed-rates" = [ "95999" ];
      #};
    }; 
  };
  
  #Enable Ibus input method, lets you write emojis too
  #i18n.inputMethod.enabled = "ibus";
  virtualisation.waydroid.enable = false;
  
  #enabling ddc brightness control
  hardware.i2c.enable = true;
  boot.kernelModules = ["i2c-dev" "ddcci_backlight" "ip_tables" "iptable_nat"];
  #boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  #This is included in the bluetooth config, as there can only be one extraModulePackages
  services.udev.extraRules = ''
        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.keyd = {};
  users.users.nixuser = {
    isNormalUser = true;
    extraGroups = [ "wheel" "dialout" "i2c" "render" "seat" "input" "keyd"]; # user groups, dialout is for some pico programming and i2c is for ddc brightness control.
    packages = with pkgs; [
      tree
      xclip
    ];
    shell= pkgs.zsh;
  };

  hardware.uinput.enable = true;
  users.groups.uinput.members = ["nixuser"];
  users.groups.input.members = ["nixuser"];
  users.groups.docker.members = ["nixuser"];

  #Install steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = false;
 
  #State Version
  system.stateVersion = "23.11";
}

