# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
   
  hardware.cpu.amd.updateMicrocode = true; 

  networking.hostName = "nixpc"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  #Stylix system theming (https://nix-community.github.io/stylix/options/platforms/nixos.html)
  stylix.enable = true;
  stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";

  hardware.opengl = {
    enable = true;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
  programs.zsh = {
    enable = true;
  };

  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g '/dev/input/by-id/usb-Razer_Razer_BlackWidow_V3_Tenkeyless-event-kbd' | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /home/nixuser/nixconfig/common/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d '/dev/input/by-id/usb-Razer_Razer_BlackWidow_V3_Tenkeyless-event-kbd'"
      DEVICE:
      MATCH:
        EV_KEY: [KEY_CAPSLOCK, KEY_RIGHTSHIFT, KEY_LEFTSHIFT]
    '';
  };

  #State Version
  system.stateVersion = "23.11";
}

