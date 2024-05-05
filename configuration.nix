# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
   
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  networking.hostName = "nixpc"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  #Environment Variables
  environment.sessionVariables = rec {
    NIXPKGS_ALLOW_UNFREE="1";
  };

  #Allow UNFREE
  nixpkgs.config.allowUnfree = true;

  #Enable flatpak
  services.flatpak.enable = true;

  #Enable Bluetooth
  hardware.bluetooth.enable = true;

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
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.  
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    extraConfig.pipewire = {
      "clock-rate-config" = {
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 8192;
      };
    }; 
  };
  
  #Enable Ibus input method, lets you write emojis too
  #i18n.inputMethod.enabled = "ibus";
  virtualisation.waydroid.enable = false;
  
  #enabling ddc brightness control
  hardware.i2c.enable = true;
  boot.kernelModules = ["i2c-dev" "ddcci_backlight"];
  boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  services.udev.extraRules = ''
        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixuser = {
    isNormalUser = true;
    extraGroups = [ "wheel" "dialout" "i2c"]; # user groups, dialout is for some pico programming and i2c is for ddc brightness control.
    packages = with pkgs; [
      firefox
      tree
      xclip
    ];
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

