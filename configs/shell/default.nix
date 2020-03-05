{ config, pkgs, ... }:

let
  pstree = "${pkgs.pstree}/bin/pstree";
  bat = "${pkgs.bat}/bin/bat";
  exa = "${pkgs.exa}/bin/exa";
in {
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    interactiveShellInit = ''
      setopt append_history
      setopt auto_cd
      setopt correct
      setopt hist_ignore_all_dups
      setopt hist_ignore_space
      setopt nomatch
      setopt notify
      setopt prompt_percent
      setopt prompt_subst
      unsetopt beep

      zstyle ":completion:*" auto-description "specify: %d"
      zstyle ":completion:*" completer _expand _complete _correct _approximate
      zstyle ":completion:*" format $'\e[38;5;247m => %d'
      zstyle ":completion:*" group-name ""
      zstyle ":completion:*" menu select=2
      eval "$(dircolors -b)"
      zstyle ":completion:*:default" list-colors "''${(s.:.)LS_COLORS}"
      zstyle ":completion:*" list-colors ""
      zstyle ":completion:*" list-prompt "%SAt %p: Hit TAB for more, or the character to insert%s"
      zstyle ":completion:*" matcher-list "" "m:{a-z}={A-Z}" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=* l:|=*"
      zstyle ":completion:*" menu select=long
      zstyle ":completion:*" select-prompt "%SScrolling active: current selection at %p%s"
      zstyle ":completion:*" use-compctl false
      zstyle ":completion:*" verbose true

      zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;31"
      zstyle ":completion:*:kill:*" command "ps -u $USER -o pid,%cpu,tty,cputime,cmd"

      stty stop "" -ixon -ixoff

      bindkey -e
      bindkey "^[[1;5D" emacs-backward-word
      bindkey "^[[1;5C" emacs-forward-word
      bindkey "^[[H"    beginning-of-line
      bindkey "^[[4~"   end-of-line
      bindkey "^[[P"    delete-char
      bindkey "^[[1~"   beginning-of-line
      bindkey "^[[3~"   delete-char
      bindkey "^V"      vi-cmd-mode

      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      bindkey "^T" transpose-chars
      bindkey "^F" fzf-file-widget
    '';

    promptInit = ''
      autoload -U promptinit colors
      promptinit
      colors

      # wraping a single character in brackets to not match its own cmdline
      onyx_zsh_prompt_in_ssh="$(${pstree} -p $$ | grep -q '[s]shd:' && echo true || echo false)"
      onyx_zsh_prompt_in_sudo="$([[ -n $SUDO_UID ]] && echo true || echo false)"

      function onyx_zsh_prompt() {
          # first line blank

          echo # start second line

          # exit status of previous command
          echo -n "%(?.   .%{$fg_bold[red]%} ⨯ )"

          # ssh indicator
          if [[ "$onyx_zsh_prompt_in_ssh" = true ]]; then
              echo -n "%{$fg_bold[magenta]%}⇄ "
          fi

          # sudo indicator
          if [[ "$onyx_zsh_prompt_in_sudo" = true ]]; then
              echo -n "%{$fg_bold[red]%}🡹 "
          fi

          # user@host ~/dir
          echo -n "%{$fg_bold[green]%}%n@%m %{$fg_bold[blue]%}%~%{$reset_color%}"

          if timeout 0.01 git rev-parse --git-dir --is-bare-repository 2>&1 | grep -q 'false' 2>&1; then
              local ref="$(timeout 0.01 git symbolic-ref HEAD 2>/dev/null)"
              local attached=true
              if [[ -z "$ref" ]]; then
                  ref="$(timeout 0.01 git describe --always HEAD 2>/dev/null)"
                  attached=false
              fi

              if [[ -n "$ref" ]]; then
                  if [[ "$attached" = false ]]; then
                      echo -n "%{$fg_bold[magenta]%} [$ref]"
                  elif [[ "$(timeout 0.02 git status --porcelain 2>&1)" != "" ]]; then
                      echo -n "%{$fg_bold[yellow]%} [''${ref#refs/heads/}]"
                  else
                      echo -n "%{$fg_bold[green]%} [''${ref#refs/heads/}]"
                  fi
              fi
          fi

          echo # start third line

          # prompt
          echo "%(!.%{$fg[red]%} # .%{$fg[cyan]%} ◆ )%{$reset_color%}"
      }

      prompt default
      setopt prompt_subst
      PS1='$(onyx_zsh_prompt)'
    '';

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" ];
    };

    shellAliases = {
      dd    = "dd status=progress";
      g     = "git";
      grep  = "grep --color=auto";
      ll    = "exa -aallgF --group-directories-first";
      llr   = "exa -algFsnew";
      llt   = "exa -lgFL2 --tree";
      nsn   = "nix-shell --command nvim";
      scu   = "systemctl --user";
      ssc   = "sudo systemctl";
      s     = "ssh";
      svim  = "sudo -E nvim";
      tree  = "exa --tree --group-directories-first";
      treel = "exa --tree -lgF --group-directories-first";
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
      --preview "echo {} | sed -re 's/ *[0-9]+ +//' | ${bat} --color=always --decorations=never --language zsh"
      --preview-window down:3:wrap
    '';

    FZF_CTRL_T_OPTS = escape ''
      --height 80%
      --preview-window down:50%
      --preview "(${bat} --color=always --style=header --paging=never {} 2> /dev/null || cat {} || ${exa} -lgFL2 --tree --color=always {} | head -200) 2> /dev/null"
    '';
  };
}
