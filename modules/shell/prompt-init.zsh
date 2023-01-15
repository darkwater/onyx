# color for prompt
__hostname_color() {
    case "$(hostname | cut -d. -f1)" in
        tetsuya) echo -n "\e[1;38;2;159;204;225;48;2;27;27;38m"   ;;
        nagumo)  echo -n "\e[1;38;2;206;16;21;48;2;36;28;22m"     ;;
        fubuki)  echo -n "\e[1;38;2;250;250;250;48;2;81;114;142m" ;;
        sinon)   echo -n "\e[1;38;2;196;252;227;48;2;48;42;3m"    ;;
        atsushi) echo -n "\e[1;38;2;189;155;235;48;2;50;50;50m"   ;;
        *)       echo -n "\e[1;38;2;200;200;200;48;2;50;50;50m"   ;;
    esac
}

__set_window_title() {
    echo -n "\e]0;$*\a"
}

__iterm2_print_state_data() {
    printf "\033]1337;RemoteHost=%s@%s\007" "$USER" "$(hostname)"
    printf "\033]1337;CurrentDir=%s\007" "$PWD"
}
__iterm2_print_state_data

__genps1() {
    local nl=$'\n'
    local bred=$'%{\e[1;31m%}'
    local green=$'%{\e[32m%}'
    local blue=$'%{\e[34m%}'
    local aqua=$'%{\e[36m%}'
    local reset=$'%{\e[0m%}'

    # bell and window title set
    echo -n "%{\a"
    __set_window_title "${USER}@$(hostname): ${PWD}"
    echo -n "%}"

    # blank line above prompt
    echo

    # start unprintable characters
    echo -n "%{"

        # iterm2 prompt mark
        echo -n "\e]133;A\a"

        # hostname color
        echo -n "$(__hostname_color)"

    # end unprintable characters
    echo -n "%}"

    echo -n " %m $reset"

    # username if not root
    if [[ "$(whoami)" != "dark" ]]; then
        echo -n " ${bred}[%n]$reset"
    fi

    # working directory
    echo -n " $blue%~"

    # prompt char
    echo -n "%(!.$bred # .$aqua %{\xe2\x97%}\x86 )$reset"

    # iterm2 prompt end mark
    echo -n "%{\e]133;B\a%}"
}

PS1="$(__genps1)"
PS2="%{%(!.$fg[red].$fg[cyan])%} | %{$reset_color%}"

preexec() {
    __preexec_called=1

    # iterm2 command executes
    echo -n "\e]133;C;\a"

    # set window title
    local cmd="$(echo "$2" | tr -d '\000-\037')"
    __set_window_title "${USER}@$(hostname): ${PWD} $ $cmd"
}

precmd() {
    local exit_status="$?"

    # iterm2 command finishes
    echo -n "\e]133;D;$exit_status\a"

    __iterm2_print_state_data

    # print exit status if non-zero
    if [ "$exit_status" != 0 ] && [ "$__preexec_called" = 1 ]; then
        echo "\e[1;31mexit $exit_status\e[0m"
        unset __preexec_called
    fi
}
