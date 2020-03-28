autoload -U promptinit colors
promptinit
colors

# wraping a single character in brackets to not match its own cmdline
onyx_zsh_prompt_in_ssh="$(pstree -p $$ | grep -q '[s]shd:' && echo true || echo false)"
onyx_zsh_prompt_in_sudo="$([[ -n $SUDO_UID ]] && echo true || echo false)"
onyx_zsh_prompt_in_nix_shell="$([[ -n $IN_NIX_SHELL ]] && echo true || echo false)"

function onyx_zsh_prompt() {
    # first line blank

    echo # start second line

    # exit status of previous command
    echo -n "%(?.   .%{$fg_bold[red]%} ⨯ )"

    # nix-shell indicator
    if [[ "$onyx_zsh_prompt_in_nix_shell" = true ]]; then
        echo -n "%{$fg_bold[blue]%}λ "
    fi

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

    # git repo info
    if timeout 0.01 git rev-parse --git-dir --is-bare-repository 2>&1 | grep -q 'false' 2>&1; then
        local ref="$(timeout 0.01 git symbolic-ref HEAD 2>/dev/null)"
        local attached=true
        if [[ -z "$ref" ]]; then
            ref="$(timeout 0.01 git describe --always HEAD 2>/dev/null)"
            attached=false
        fi

        if [[ -n "$ref" ]]; then
            if [[ "$attached" = false ]]; then
                echo -n "%{$fg_bold[magenta]%}"
            elif [[ "$(timeout 0.05 git status --porcelain 2>&1)" != "" ]]; then
                echo -n "%{$fg_bold[yellow]%}"
            elif [[ $? = 124 ]]; then # git status timed out
                # default text color
            else
                echo -n "%{$fg_bold[green]%}"
            fi
            echo -n "[${ref#refs/heads/}]"
        fi
    fi

    echo # start third line

    # prompt
    echo "%(!.%{$fg[red]%} # .%{$fg[cyan]%} ◆ )%{$reset_color%}"
}

prompt default
setopt prompt_subst
PS1='$(onyx_zsh_prompt)'
