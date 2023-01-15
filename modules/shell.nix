{ config, pkgs, lib, ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    histSize = 100000;

    interactiveShellInit = builtins.readFile (pkgs.substituteAll {
      src = shell/interactive-shell-init.zsh;
      inherit (pkgs) fzf;
    });

    promptInit =
      builtins.readFile shell/prompt-init.zsh;

    shellInit = ''
      # disable newuser setup
      zsh-newuser-install() { :; }
    '';

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" ];
    };

    shellAliases = rec {
      # also see functions in interactive-shell-init.zsh
      c     = "cargo";
      dd    = "dd status=progress";
      g     = "git";
      ip    = "ip --color=auto";
      l     = null;
      lr    = "exa -algFsnew";
      lt    = "exa -lgFL2 --tree";
      om    = "overmind";
      pql   = "pacman -Ql";
      psi   = "pacman -Si";
      pss   = "pacman -Ss";
      r     = "bundle exec rails";
      s     = "ssh";
      sai   = "sudo apt install";
      scu   = "systemctl --user";
      sd    = "sudo docker";
      sl    = "sudo exa -Flgaa --group-directories-first";
      slr   = "sudo ${lr}";
      slt   = "sudo ${lt}";
      sps   = "sudo pacman -S";
      spsyu = "sudo pacman -Syu";
      ssc   = "sudo systemctl";
      svim  = "sudo -E nvim";
      tree  = "exa --tree --group-directories-first";
      treel = "exa --tree -lgF --group-directories-first";
      x     = "cargo xtask";
    };
  };

  environment.variables = let
    escape = builtins.replaceStrings ["\n" "\""] [" " "\\\""];
  in {
    BAT_THEME = "ansi";
    EDITOR = "nvim";
    VISUAL = "nvim";

    FZF_DEFAULT_OPTS = escape ''
      --bind "change:top,ctrl-y:preview-up+preview-up+preview-up,ctrl-e:preview-down+preview-down+preview-down"
    '';

    FZF_CTRL_R_OPTS = escape ''
      --preview "echo {} | sed -re 's/ *[0-9]+ +//' | bat --color=always --decorations=never --language zsh"
      --preview-window down:3:wrap
    '';

    FZF_CTRL_T_OPTS = escape ''
      --height 80%
      --preview-window down:50%
      --preview "(bat --color=always --style=header --paging=never {} 2> /dev/null || cat {} || exa -lgFL2 --tree --color=always {} | head -200) 2> /dev/null"
    '';
  };
}
