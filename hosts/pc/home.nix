#Home manager config (https://home-manager-options.extranix.com/)

{ pkgs, lib, caelestia, inputs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      la = "ls -a";
      ll = "ls -l";
      lla = "ls -la";
      nixswitch = "sudo nixos-rebuild switch --flake /home/nixuser/nixconfig#nixpc";
    };
    initExtra = ''
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      PROMPT="%{%F{green}%}%n@%m%{%F{blue}%}(%D{%H:%M})($SHLVL)%{%F{green}%}: [%{%F{red}%}$CONTAINER_ID%{%F{blue}%}%~%{%F{green}%}]%(!.#.$)%{%f%} "
    '';
    initContent = lib.mkOrder 1500 ''
      zstyle ':completion:*' ignored-patterns 'flake.lock' '*/flake.lock' 'Cargo.lock' '*/Cargo.lock'
      zstyle ':completion:*' single-ignored show
    '';
    syntaxHighlighting.enable = true;

  };
  programs.zoxide.enable = true;
  programs.ghostty.enable = true;

  programs.caelestia = {
    enable = true;
    cli = {
      enable = true;
    };
  };

  # Mime config (setting default apps, for all types run: cat /etc/profiles/per-user/nixuser/share/mime/packages/freedesktop.org.xml | grep "mime-type type=" | nvim)
  home.file.".config/xfce4/helpers.rc".text = ''
    [TerminalEmulator]
    Command=ghostty
    Exec=ghostty
  '';
  xdg.enable = true;
  xdg.mimeApps.defaultApplications = {
    "video/mp4" = ["mpv.desktop"];
    "video/mkv" = ["mpv.desktop"];
    "image/png" = ["qimgv.desktop"];
    "image/jpeg" = ["qimgv.desktop"];
    "image/gif" = ["qimgv.desktop"];
    "image/webp" = ["qimgv.desktop"];
    "inode/directory" = ["thunar.desktop"];
    "text/plain" = ["neovim.desktop"];
    "application/pdf" = ["firefox.desktop"];
  };
  xdg.mimeApps.associations.removed = {
    "application/pdf" = "chromium-browser.desktop";
  };
  xdg.configFile."mimeapps.list".force = true;
  xdg.desktopEntries.Citron = {
    name = "Citron";
    genericName = "Switch Emulator";
    exec = "steam-run /home/nixuser/AppImages/Citron.AppImage";
    comment = "Nintendo Switch video game console emulator";
    type = "Application";
    icon = "/home/nixuser/AppImages/Icons/org.citron_emu.citron.svg";
  };
  xdg.desktopEntries.Hayase = {
    name = "Hayase";
    genericName = "Anime Streaming App";
    exec = "appimage-run /home/nixuser/AppImages/Hayase.AppImage";
    comment = "Anime Streaming/Torrenting App";
    type = "Application";
    icon = "/home/nixuser/AppImages/Icons/org.hayase.hayase.webp";
  };

  #Stylix user theming (https://nix-community.github.io/stylix/options/platforms/home_manager.html)
  stylix = {
    targets = {
      gtk = {
        enable = true;
        flatpakSupport.enable = true;
      };
      ghostty.enable = true;
    };

    fonts.sizes.terminal = 13;

    iconTheme = {
      enable = true;
      package = pkgs.qogir-icon-theme;
      dark = "Qogir-Dark";
      light = "Qogir-Light";
    };

    cursor = {
      package = pkgs.bibata-cursors;
      size = 24;
      name = "Bibata-Modern-Classic";
    };
  };
}
