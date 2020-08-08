{}:

{
  # it's probably a good idea to use the same revision of unstable everywhere
  unstable = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/b8c367a7bd0.tar.gz") {
    config.allowUnfree = true;
  };

  overlay = self: super: rec {
    brightctl                 = self.callPackage ./pkgs/brightctl {};
    cargo-embed               = self.callPackage ./pkgs/cargo-embed {};
    cargo-node                = self.callPackage ./pkgs/cargo-node {};
    crc16                     = self.callPackage ./pkgs/crc16 {};
    onyx-nvim-pack            = self.callPackage ./pkgs/onyx-nvim-pack {};
    openocd-rtt               = self.callPackage ./pkgs/openocd-rtt {};
    pjstore                   = self.callPackage ./pkgs/pjstore {};
    polybar                   = self.callPackage ./pkgs/polybar {};
    unvpk                     = self.callPackage ./pkgs/unvpk {};

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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFEyf3k/BubYjMNUOGlhUJ2m2/oUAGNpvWZZw2V1SmJA2WloDqmoT3ChPR9WVwpFEaxr4kH8Nc+k9Nq5qn5ndWMTMV8oz5t9N77u3hIKeGc2xQ+sz+KOvOY7pSFd0ZfASry3NTZgxdVdfrekEViw6XjCF+ab0fkJPRPkr1OmT2wz7r8JeF01UT/A0BVWKWhkG57YDbzk8+XqsakTu5SBhbGfsC3vt9iyFzVqmy+TecylercF3+3q95tkjon+DV5sMHsvMqM71Vqs3yigEUDn9XSOk8NncaVHNtMeDch82IfaJ3Da7KMc0B4fDgH8oXKuhTpjq6xxUFo9Ny2q8FyPVX dark@tetsuya"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsSVCcw/Ydi5BZec9a1wO/fucMUkdZoxEQLlWAwKI41oKh1Ca68/FQAI4zF92HzcVZN6QOZqVBkPm0fdc5JvPGc7HHfVtIDONsRgk+XFD3DllB+nSssc3JRqdSlUmii9CW6cAhEUdUpGhsTGxfSNfRyDA9p9nZCHW8kmz6l3Vx+irlBaflyP3yHvbKnbADiQTwBxIlY+yE9XXZEZ3TRUaBxla9EPbbJuNChzaVcurmcay305uBFdYZizV0SP+nZymJS64WBoBjCvJ27YXhSs/bJWnBXrjFryIJRv0RUgV6w/1C41mSecVQUiwFVV/tx1sMCqWKEgtE4T1Umemb15Y9 dark@nagumo"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpxZidbLQlFbtMhkGMY76xdfDlac6SpipG/gB0fQYJU07rOqYfZbiJgNrlgHcv6cdZAm6xbgWkcM0PZXaAsMzom5YI0bJTIXQhqls6/pNLV4TnjuuPx9W8nokalWx96PizzRQtJY8B/j8tJFJ7qXhslFg+URWaSt2HKqHiJD68bWy4YVitzjO/HXGSbHW0GBqW7UG2xgZyNo+vYp0EX6GBjVXB1PZp2hBEEOzOMMqJI4MCYOr12oLUWGokEtZZWrSqlJ1s/MpX6NOr5eMGl2fSN8wGKNsd9CUYOgbfUIqwUu0nXx5vu3GHqkdPShb1tGXciSCNT+1GXF9nzOvnJTW7 dark@sekiban"
    ];
    mro95 = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCCdJXwqPLO9BS5nGICQSWMlFy4+u96GbfAqXWxMjSw mro95@mro95-laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6ZuQBDelB5IZWfWqwBYAaEIrICMGfnd8UEzHyDHNNW mro95@mro95-desktop"
    ];
  };
}
