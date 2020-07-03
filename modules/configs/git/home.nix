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
        st = "status";
        ci = "commit --verbose";
        ca = "commit --verbose --all";
        co = "checkout";
        di = "diff";
        dc = "diff --cached";
        ds = "diff --stat=160,120";
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
