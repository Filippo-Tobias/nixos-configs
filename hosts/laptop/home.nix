{pkgs, lib, ...}:

{
  imports = [
  ];
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      };
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      la = "ls -a";
      ll = "ls -l";
      lla = "ls -la";
      nixswitch = "sudo nixos-rebuild switch --flake /home/nixuser/nixconfig#nixlaptop";
    };
    initExtra = ''
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      PROMPT="%{%F{green}%}%n@%m%{%F{blue}%}(%D{%H:%M})($SHLVL)%{%F{green}%}:%{%F{blue}%}%~%{%F{green}%}%(!.#.$)%{%f%} "
    '';
    initContent = lib.mkOrder 1500 ''
      zstyle ':completion:*' ignored-patterns 'flake.lock' '*/flake.lock'
      zstyle ':completion:*' single-ignored show
    '';
    syntaxHighlighting.enable = true;

  };

  programs.kitty.enable = true;

  programs.zoxide.enable = true;

  # Mime config (setting default apps, for all types run: cat /etc/profiles/per-user/nixuser/share/mime/packages/freedesktop.org.xml | grep "mime-type type=" | nvim)
  xdg.mimeApps.defaultApplications = {
    "video/mp4" = ["mpv.desktop"];
    "video/mkv" = ["mpv.desktop"];
    "image/png" = ["qimgv.desktop"];
    "image/jpeg" = ["qimgv.desktop"];
    "image/gif" = ["qimgv.desktop"];
    "image/webp" = ["qimgv.desktop"];
    "inode/directory" = ["dolphin.desktop"];
  };

  #Stylix user theming (https://nix-community.github.io/stylix/options/platforms/home_manager.html)
  stylix.targets.gtk.enable = true;
  stylix.targets.kitty.enable = true;
  stylix.targets.gtk.flatpakSupport.enable = true;
  stylix.iconTheme.enable = true;
  stylix.iconTheme.package = pkgs.qogir-icon-theme;
  stylix.iconTheme.dark = "Qogir-Dark";
  stylix.iconTheme.light = "Qogir-Light";
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    size = 24;
    name = "Bibata-Modern-Classic";
  };
}

