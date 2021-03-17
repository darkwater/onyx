{}:

rec {
  # it's probably a good idea to use the same revision of unstable everywhere
  unstable = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/ea3638a3fb2.tar.gz") {
    config.allowUnfree = true;
  };

  overlay = self: super: rec {
    autorandr2                = self.callPackage ./pkgs/autorandr2 {};
    brightctl                 = self.callPackage ./pkgs/brightctl {};
    cargo-embed               = self.callPackage ./pkgs/cargo-embed {};
    cargo-node                = self.callPackage ./pkgs/cargo-node {};
    crc16                     = self.callPackage ./pkgs/crc16 {};
    itm-tools                 = self.callPackage ./pkgs/itm-tools {};
    onyx-nvim-pack            = self.callPackage ./pkgs/onyx-nvim-pack { inherit unstable; };
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

    onyx-shells = {
      rust = self.callPackage ./shells/rust {};
    };

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
      "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAHbNgyd3ECJCfC62iTSApBzHUBhoexLzxJLlps3DJ8e91G6ZyyOLTkHz/vESfsuwdU5BzQk82TYcSHYmwspXu6EvAG5QuLW5gl3dv0s3+ZK0sU1RH/L+8oqbH1P84Nu6nRasCxe67O50rUKu5c0UYPF+G4kW7nT7KBg00H7nt+knVPYiA== dark@sekiban"
    ];
    mro95 = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCCdJXwqPLO9BS5nGICQSWMlFy4+u96GbfAqXWxMjSw mro95@mro95-laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6ZuQBDelB5IZWfWqwBYAaEIrICMGfnd8UEzHyDHNNW mro95@mro95-desktop"
    ];
    jelle = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKJHZOF7r5GBo6n2L9CzymDPeOInfTpRJUZ/a/VZ4fX jelle@thee"
    ];
  };
}
