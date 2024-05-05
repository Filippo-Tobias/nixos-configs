{ config, lib, pkgs, ... }:

# List packages installed in system profile. To search, run:
# $ nix search wget

{
environment.systemPackages = with pkgs; [
    vim
    wget
    gnome.gnome-tweaks
    xclip
    clipnotify
    vscode
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
  ];
}