{ config, lib, pkgs, ... }:

{
imports = [
     ./extraEnviromentPackages.nix
];

#For packages in nixpkgs
environment.systemPackages = with pkgs; [
    wl-clipboard
    mpv
    distrobox
    sway-contrib.grimshot
    slurp
    gnomeExtensions.gsconnect
    gnome-disk-utility
    kdePackages.qtsvg #required for icons for doplhin
    kdePackages.dolphin
    deluge
    xdg-desktop-portal-hyprland
    hyprlock
    linux-wallpaperengine
    mpvpaper
    kitty
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
    aseprite
    discord
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
