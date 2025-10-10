{ config, system, lib, pkgs, ... }:
let
  oldPkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/882842d2a908700540d206baa79efb922ac1c33d.tar.gz";
    sha256 = "105v2h9gpaxq6b5035xb10ykw9i3b3k1rwfq4s6inblphiz5yw7q";
  }) {
    inherit system;
  };
in {
  #For packages in nixpkgs
  environment.systemPackages = with pkgs; [
      pyright
      iptables
      docker-compose
      freerdp
      resnap
      tmux
      brightnessctl
      pywal
      docker-compose
      freerdp
      ffmpeg
      deno
      heroic
      xfce.thunar-archive-plugin
      file-roller
      obsidian
      qimgv
      obs-studio
      oldPkgs.gamescope
      modrinth-app
      keyd
      xorg.xorgserver
      unzip
      hyprpolkitagent
      opencl-headers
      chromium
      unrar
      mangohud
      rar
      p7zip-rar
      p7zip
      lua-language-server
      wine64
      wl-clipboard
      r2modman
      mpv
      gamemode
      distrobox
      sway-contrib.grimshot
      slurp
      gnomeExtensions.gsconnect
      gnome-disk-utility
      deluge
      xdg-desktop-portal-hyprland
      hyprlock
      mpvpaper
      wofi
      vim
      wget
      refind
      gnome-tweaks
      xclip
      clipnotify
      thonny
      killall
      prismlauncher
      htop
      radeontop
      godot_4
      libreoffice
      git
      (discord.override {
        withVencord = true;
      })
      lutris
      steam-run
      appimage-run
      ddcutil
      gnomeExtensions.brightness-control-using-ddcutil
      neovim
      luajitPackages.lua-lsp
      nil
      ripgrep
      #nerd-fonts.fira-code 
    ];

  nixpkgs.config.permittedInsecurePackages = [
      "freeimage-unstable-2021-11-01"
  ];

}
