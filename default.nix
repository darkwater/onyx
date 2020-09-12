{}:

{
  # it's probably a good idea to use the same revision of unstable everywhere
  unstable = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/3c0e3697520.tar.gz") {
    config.allowUnfree = true;
  };

  overlay = self: super: rec {
    brightctl                 = self.callPackage ./pkgs/brightctl {};
    cargo-embed               = self.callPackage ./pkgs/cargo-embed {};
    cargo-node                = self.callPackage ./pkgs/cargo-node {};
    crc16                     = self.callPackage ./pkgs/crc16 {};
    itm-tools                 = self.callPackage ./pkgs/itm-tools {};
    onyx-nvim-pack            = self.callPackage ./pkgs/onyx-nvim-pack {};
    pjstore                   = self.callPackage ./pkgs/pjstore {};
    polybar                   = self.callPackage ./pkgs/polybar {};
    unvpk                     = self.callPackage ./pkgs/unvpk {};

    dolphin-master = self.callPackage ./pkgs/dolphin-master {
      qtbase = self.qt5.qtbase;
      wrapQtAppsHook = self.qt5.wrapQtAppsHook;
    };

    mumble = (self.callPackages ./pkgs/mumble {
      avahi = self.avahi.override {
        withLibdnssdCompat = true;
      };
      jackSupport = true;
      pulseSupport = true;
    }).mumble;

    nodePackages = (super.nodePackages or {}) // import ./pkgs/nodePackages { pkgs = self; };
    vimPlugins   = (super.vimPlugins or {}) // self.callPackage ./pkgs/vimPlugins {};

    inherit (self.callPackage ./lib/extra-builders.nix {}) writeRubyScriptBin;
  };

  modules = {
    imports = [
      ./modules/configs/nvim
      ./modules/configs/shell
      ./modules/services/pjstore
    ];
  };

  home-modules = {
    imports = [
      ./modules/configs/git/home.nix
      ./modules/configs/nvim/home.nix
      # ./modules/configs/shell/home.nix
    ];
  };

  sshKeys = {
    dark = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILv7pO+bnKImaSQPnvPRJzpJ+ditlPzmTccY5x9nxfpt dark@tetsuya"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMczdUseE7jrjikFSivN8YfK7aurDK/U0KxD71+q7Wjo dark@nagumo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMlR1hlRwZqXB1xQbaCywxmpI0y3Sj1qcpfdOWnQLJW dark@sekiban"
    ];
    mro95 = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCCdJXwqPLO9BS5nGICQSWMlFy4+u96GbfAqXWxMjSw mro95@mro95-laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6ZuQBDelB5IZWfWqwBYAaEIrICMGfnd8UEzHyDHNNW mro95@mro95-desktop"
    ];
  };
}
