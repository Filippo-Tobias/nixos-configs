# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "nixpc"; # Define your hostname.
  # Pick only one of the below networking options.

  programs.zsh = {
    enable = true;
    shellAliases = {
      la = "ls -a";
      ll = "ls -l";
      lla = "ls -la";
      nixswitch = "sudo nixos-rebuild switch --flake /home/nixuser/nixconfig#nixlaptop";
    };
  }; 
  
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
    - JOB: "${pkgs.interception-tools}/bin/intercept -g '/dev/input/by-path/platform-i8042-serio-0-event-kbd' | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /home/nixuser/nixconfig/common/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d '/dev/input/by-path/platform-i8042-serio-0-event-kbd'"
    DEVICE:
    MATCH:
      EV_KEY: [KEY_CAPSLOCK, KEY_RIGHTSHIFT, KEY_LEFTSHIFT]
    '';
  };
  #State Version
  system.stateVersion = "23.11";
}

