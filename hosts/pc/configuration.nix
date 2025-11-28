# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
    PubkeyAcceptedKeyTypes ssh-ed25519
    ServerAliveInterval 60
    IPQoS throughput
    IdentityFile /home/nixuser/.ssh/id_ed25519
  '';
  
  nix = {
    distributedBuilds = true;
    buildMachines = [
      { hostName = "eu.nixbuild.net";
        system = "x86_64-linux";
        maxJobs = 100;
        supportedFeatures = [ "benchmark" "big-parallel" ];
      }
    ];
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
   
  hardware.cpu.amd.updateMicrocode = true; 
  environment.systemPackages = with pkgs; [
    openrazer-daemon
    polychromatic
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
  };
  swapDevices = [];

  xdg.mime.defaultApplications = {
    "video/mp4" = ["mpv.desktop"];
    "video/mkv" = ["mpv.desktop"];
    "image/png" = ["qimgv.desktop"];
    "image/jpeg" = ["qimgv.desktop"];
    "image/gif" = ["qimgv.desktop"];
    "image/webp" = ["qimgv.desktop"];
    "inode/directory" = ["thunar.desktop"];
    "text/plain" = ["kate.desktop"];
  };

  boot.resumeDevice = "/dev/disk/by-uuid/ebd8b58a-357e-40cb-9185-1af0131fa36e";

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };

  users.extraGroups.libvirtd = {
    members = [ "nixuser" ];
  };

  hardware.openrazer.enable = true;
  users.users.nixuser = { extraGroups = [ "openrazer" ]; };

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
    - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /home/nixuser/nixconfig/common/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
      DEVICE:
        LINK: /dev/input/by-id/usb-Razer_Razer_BlackWidow_V3_Tenkeyless-event-kbd
  '';
};
  systemd.services.interception-tools = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  #State Version
  system.stateVersion = "23.11";
}

