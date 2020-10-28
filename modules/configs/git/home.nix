{ config, pkgs, lib, ... }:

let
  cfg = config.onyx.configs.git;
in {
  options.onyx.configs.git = with lib; {
    enable = mkEnableOption "git configuration";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          config.programs.git.signing.signByDefault ->
          (config.programs.git.signing.key != "");

        message = ''
          You should sign your git commits:
            set: programs.git.signing.key = "gpg-key@to.use";
            or:  programs.git.signing.signByDefault = false;
        '';
      }
    ];

    home.packages = [
      (pkgs.writeShellScriptBin "git-undo" ''
        git log -g --abbrev-commit --pretty=oneline --decorate --color=always \
        | sed -e 's/HEAD@{[0-9]\+}: commit: //' -e "s/HEAD@{[0-9]\+}: /$(tput setaf 4)/" \
        | fzf --ansi --layout=reverse --border --height=16 \
        | cut -d\  -f1 \
        | if read hash; then
            git reset --hard "$hash"
          fi
      '')

      (pkgs.writeShellScriptBin "git-l" ''
        LOG_HASH="%C(always,yellow)%h%C(always,reset)"
        LOG_RELATIVE_TIME="%C(always,magenta)%ar##ago%C(always,reset)"
        LOG_AUTHOR="%C(always,bold black)<%an>%C(always,reset)"
        LOG_SUBJECT="%s"
        LOG_REFS="%C(always,bold red)%d%C(always,reset)"
        tab=$'\t'
        LOG_FORMAT="$tab$LOG_HASH$tab$LOG_RELATIVE_TIME$tab%G?##gpgsig  subject##$LOG_SUBJECT $LOG_REFS $LOG_AUTHOR"

        COLUMNS=$(tput cols)

        pretty_git_format() {
          sed -Ee '
            s/ years?, ?([[:digit:] ]{2}) months? ago##ago/y \1mo/
            s/ seconds? ago##ago/s /
            s/ minutes? ago##ago/mt/
            s/ hours? ago##ago/h /
            s/ days? ago##ago/d /
            s/ weeks? ago##ago/wk/
            s/ months? ago##ago/mo/
            s/ years? ago##ago/y     /
            s/ ago##ago//

            s/([G])##gpgsig/\x1b[32m\1\x1b[0m/
            s/([UXYRE])##gpgsig/\x1b[33m\1\x1b[0m/
            s/([A-Z])##gpgsig/\x1b[31m\1\x1b[0m/

            s/subject##([^ ]+: )*/\x1b[34m\1\x1b[0m/
          ' |
          column -s $'\t' -t -R 3
        }

        git_page_maybe() {
          # Page only if we're asked to.
          if [ -n "$GIT_NO_PAGER" ]; then
            cat
          else
            # Page only if needed.
            less --quit-if-one-screen --no-init --RAW-CONTROL-CHARS --chop-long-lines
          fi
        }

        git log --graph --pretty="tformat:$LOG_FORMAT" --no-show-signature "$@" | pretty_git_format | git_page_maybe
      '')

      (pkgs.writeShellScriptBin "git-wip" ''
        if [[ $# = 0 ]]; then
          echo "usage:"
          echo "  git wip list [<remote>]           - list all works in progress on the remote"
          echo "  git wip push [<remote>] [<label>] - stash and push your uncommitted changes"
          echo "  git wip pull [<remote>] [<label>] - pull and apply some wip stash"
          echo "               (remote defaults to: origin)"
          echo "               (label defaults to: <username>/<git describe>)"
        fi

        set -e

        cmd="$1"
        remote="''${2:-origin}"
        label="''${3:-"$USER/$(git describe --all)"}"

        list()
        {
          echo "WIP stashes on $remote:"
          git ls-remote "$remote" "refs/wip/*"
        }

        push()
        {
          git stash --include-untracked
          git push -f "$remote" "refs/stash:refs/wip/$label"
        }

        pull()
        {
          git fetch "$remote" refs/wip/$label
          git stash apply FETCH_HEAD
        }

        case "$cmd" in
          list) list;;
          push) push;;
          pull) pull;;
        esac
      '')
    ];

    programs.git = {
      enable = true;

      signing.signByDefault = lib.mkDefault true;
      signing.key = lib.mkDefault "";

      aliases = {
        r = "!GIT_NO_PAGER=1 git l -30";
        ra = "!git r --all";
        la = "!git l --all";
        st = "status";
        ci = "commit --verbose";
        ca = "commit --verbose --all";
        co = "checkout";
        di = "diff";
        dc = "diff --cached";
        ds = "diff --stat=80";
        dt = "difftool";
        aa = "add --all";
        ai = "add --interactive";
        ap = "add --patch";
        ff = "merge --ff-only";
        fa = "fetch --all";
        dh1 = "diff HEAD~1";
        pom = "push origin master";
        noff = "merge --no-ff";
        amend = "commit --amend";
        pullff = "pull --ff-only";
      };

      ignores = [
        ".gdb_history"
        ".DS_Store"
        "*~"
      ];
    };
  };
}
