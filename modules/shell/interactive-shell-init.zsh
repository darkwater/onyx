setopt append_history
setopt auto_cd
setopt correct
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt nomatch
setopt notify
setopt prompt_subst
unsetopt beep

if groups | grep -q '\<wheel\>'; then
    booted="$(readlink /run/booted-system/{kernel,kernel-modules})"
    built="$(readlink /nix/var/nix/profiles/system/{kernel,kernel-modules})"
    if [[ "$booted" != "$built" ]]; then
        echo "Kernel upgraded; restart required"

        from="$(file $(readlink /run/booted-system/kernel) | grep -oE 'version ([0-9.]+)')"
        to="$(file $(readlink /nix/var/nix/profiles/system/kernel) | grep -oE 'version ([0-9.]+)')"
        if [[ "$from" = "$to" ]]; then
            echo "$from (modules changed)"
        else
            echo "$from -> $to"
        fi
    fi
fi

zstyle ":completion:*" auto-description "specify: %d"
zstyle ":completion:*" completer _expand _complete _correct _approximate
zstyle ":completion:*" format $'\e[38;5;247m => %d'
zstyle ":completion:*" group-name ""
zstyle ":completion:*" menu select=2
eval "$(dircolors -b)"
zstyle ":completion:*:default" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*" list-colors ""
zstyle ":completion:*" list-prompt "%SAt %p: Hit TAB for more, or the character to insert%s"
zstyle ":completion:*" matcher-list "" "m:{a-z}={A-Z}" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=* l:|=*"
zstyle ":completion:*" menu select=long
zstyle ":completion:*" select-prompt "%SScrolling active: current selection at %p%s"
zstyle ":completion:*" use-compctl false
zstyle ":completion:*" verbose true

zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;31"
zstyle ":completion:*:kill:*" command "ps -u $USER -o pid,%cpu,tty,cputime,cmd"

bindkey -e
bindkey "^[[1;5D" emacs-backward-word
bindkey "^[[1;5C" emacs-forward-word
bindkey "^[[H"    beginning-of-line
bindkey "^[[4~"   end-of-line
bindkey "^[[P"    delete-char
bindkey "^[[1~"   beginning-of-line
bindkey "^[[3~"   delete-char
bindkey "^V"      vi-cmd-mode
stty stop "" -ixon -ixoff

# like ^W but for path segments
backward-kill-dir () {
    local WORDCHARS="\\ ${WORDCHARS/\/}"
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[w' backward-kill-dir

source @fzf@/share/fzf/key-bindings.zsh
bindkey "^T" transpose-chars
bindkey "^F" fzf-file-widget

man() { nvim +"Man $*" +only }

l() {
    # -aa only in $HOME and without arguments
    aa="$([[ "$(pwd)" = "$HOME" && "$#" = 0 ]] || echo -n aa)"
    eza -Flg$aa --group-directories-first "$@"
}

downloads() {
    cd ~/?ownloads/ && ls -Fal -tcreated --color=always | head -n 11 | tail | tac
}
