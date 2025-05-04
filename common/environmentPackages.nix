{ config, lib, pkgs, ... }:

{
imports = [
     ./extraEnvironmentPackages.nix
];

#For packages in nixpkgs
environment.systemPackages = with pkgs; [
    lua-language-server
    wine64
    wl-clipboard
    r2modman
    mpv
    gamescope
    gamemode
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
