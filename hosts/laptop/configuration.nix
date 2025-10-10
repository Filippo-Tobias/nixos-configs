# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    power-profiles-daemon.enable = true;
  };

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a;

  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  networking.hostName = "nixlaptop"; # Define your hostname.
  services.system76-scheduler.settings.cfsProfiles.enable = true;
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_BOOST_ON_AC = 1;
  #     CPU_BOOST_ON_BAT = 0;
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     START_CHARGE_THRESH_BAT0 = 0;
  #     STOP_CHARGE_THRESH_BAT0 = 100;
  #   };
  # };
  # services.power-profiles-daemon.enable = false;
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  # Pick only one of the below networking options.

  #Stylix system theming (https://nix-community.github.io/stylix/options/platforms/nixos.html)
  stylix.enable = true;
  stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";

  programs.zsh = {
    enable = true;
  }; 

  services.logind.lidSwitch = "ignore";
  
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
    - JOB: "${pkgs.interception-tools}/bin/intercept -g '/dev/input/by-path/platform-i8042-serio-0-event-kbd' | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /home/nixuser/nixconfig/hosts/laptop/dual-function-keys-0.yaml | ${pkgs.interception-tools}/bin/uinput -d '/dev/input/by-path/platform-i8042-serio-0-event-kbd'"
    DEVICE:
    MATCH:
      EV_KEY: [KEY_CAPSLOCK, KEY_LEFTMETA]
    '';
  };
  #State Version
  system.stateVersion = "23.11";
}

