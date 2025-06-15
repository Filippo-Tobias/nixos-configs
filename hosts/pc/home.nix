{ pkgs, ... }:

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
      nix() {
        if [[ "$1" == "develop" || "$1" == "shell" ]]; then
          subcmd=$1
          shift
          command nix "$subcmd" "$@" -c "$SHELL" 
        else
          command nix "$@"
        fi
      }
      nix-shell() {
        command nix-shell "$@" --command "$SHELL" 
      }

      PROMPT="%{%F{green}%}%n@%m%{%F{blue}%}(%D{%H:%M})($SHLVL)%{%F{green}%}:%{%F{blue}%}%~/%{%F{green}%}%(!.#.$)%{%f%} "
    '';
    syntaxHighlighting.enable = true;

  };
  programs.zoxide.enable = true;

}

