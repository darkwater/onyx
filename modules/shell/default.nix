{ config, pkgs, lib, shino, hermes, ... }:

let
  cfg = config.onyx.shell;
in
{
  options.onyx.shell = {
    enable = lib.mkEnableOption "onyx shell";

    defaultUser = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "Hide username in prompt when logged in as this user.";
    };

    hostnameColor = lib.mkOption {
      type = lib.types.submodule {
        options = {
          fg = lib.mkOption {
            type = lib.types.listOf lib.types.int;
            description = "Foreground color.";
          };

          bg = lib.mkOption {
            type = lib.types.listOf lib.types.int;
            description = "Background color.";
          };
        };
      };
      default = {
        fg = [ 200 200 200 ];
        bg = [ 50 50 50 ];
      };
      description = "Color for hostname in prompt.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [ "/share/zsh" ];

    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      histSize = 100000;

      interactiveShellInit = builtins.readFile (pkgs.substituteAll {
        src = ./interactive-shell-init.zsh;
        inherit (pkgs) fzf;
      });

      promptInit = builtins.readFile (pkgs.substituteAll {
        src = ./prompt-init.zsh;
        defaultUser = cfg.defaultUser;
        hostnameColorFg = lib.concatStringsSep ";" (builtins.map (n: toString n) cfg.hostnameColor.fg);
        hostnameColorBg = lib.concatStringsSep ";" (builtins.map (n: toString n) cfg.hostnameColor.bg);
      });

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
        c = "cargo";
        dd = "dd status=progress";
        g = "git";
        ip = "ip --color=auto";
        l = null;
        lr = "eza -algFsnew";
        lt = "eza -lgFL2 --tree";
        om = "overmind";
        pql = "pacman -Ql";
        psi = "pacman -Si";
        pss = "pacman -Ss";
        r = "bundle exec rails";
        s = "ssh";
        scu = "systemctl --user";
        sd = "sudo docker";
        sl = "sudo eza -Flgaa --group-directories-first";
        slr = "sudo ${lr}";
        slt = "sudo ${lt}";
        ssc = "sudo systemctl";
        svim = "sudo -E nvim";
        tree = "eza --tree --group-directories-first";
        treel = "eza --tree -lgF --group-directories-first";
      };
    };

    environment.variables =
      let
        escape = builtins.replaceStrings [ "\n" "\"" ] [ " " "\\\"" ];
      in
      {
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
          --preview "(bat --color=always --style=header --paging=never {} 2> /dev/null || cat {} || eza -lgFL2 --tree --color=always {} | head -200) 2> /dev/null"
        '';
      };

    environment.systemPackages = with pkgs; [
      acpi
      bat
      du-dust
      ed
      eza
      fd
      fzf
      htop
      gnupg
      imagemagick
      jq
      netcat-gnu
      pstree
      pv
      ripgrep
      ruby
      rubyPackages_3_1.pry
      screen
      socat
      tmux
      wget
      xxd

      shino.defaultPackage.x86_64-linux
      hermes.defaultPackage.x86_64-linux
    ];
  };
}
