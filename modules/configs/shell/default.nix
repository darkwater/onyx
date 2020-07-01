{ config, pkgs, lib, ... }:

let
  cfg = config.onyx.configs.shell;
in {
  options.onyx.configs.shell = with lib; {
    enable = mkEnableOption "shell configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bat exa fzf git htop wget pstree
    ];

    environment.pathsToLink = [ "/share/zsh" ];

    users.defaultUserShell = pkgs.zsh;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      histSize = 100000;

      interactiveShellInit = pkgs.substituteAll {
        src = ./interactive-shell-init.zsh;
        inherit (pkgs) fzf;
      };

      promptInit =
        builtins.readFile ./prompt-init.zsh;

      shellInit = ''
        # disable newuser setup
        zsh-newuser-install() { :; }
      '';

      syntaxHighlighting = {
        enable = true;
        highlighters = [ "main" "brackets" "pattern" ];
      };

      shellAliases = rec {
        dd    = "dd status=progress";
        g     = "git";
        grep  = "grep --color=auto";
        ll    = "exa -aallgF --group-directories-first";
        llr   = "exa -algFsnew";
        llt   = "exa -lgFL2 --tree";
        sll   = "sudo ${ll}";
        sllr  = "sudo ${llr}";
        sllt  = "sudo ${llt}";
        scu   = "systemctl --user";
        ssc   = "sudo systemctl";
        s     = "ssh";
        svim  = "sudo -E nvim";
        tree  = "exa --tree --group-directories-first";
        treel = "exa --tree -lgF --group-directories-first";
        # also see functions in interactive-shell-init.zsh
      };
    };

    environment.variables = let
      escape = builtins.replaceStrings ["\n" "\""] [" " "\\\""];
    in {
      BAT_THEME = "ansi-dark";
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
  };
}
