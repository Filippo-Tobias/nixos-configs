{ config, lib, pkgs, ... }:

# List packages installed in system profile. To search, run:
# $ nix search wget

{
environment.systemPackages = with pkgs; [
    gnomeExtensions.gsconnect
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
    (nerdfonts.override {fonts = ["FiraCode"];}) 
  ];
}
