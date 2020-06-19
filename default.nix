{ nonredistKey ? "" }:

{
  overlay = self: super: {
    brightctl                 = super.callPackage ./pkgs/brightctl {};
    cargo-node                = super.callPackage ./pkgs/cargo-node {};
    factorio-headless         = super.callPackage ./pkgs/factorio {};
    minecraft-server-snapshot = super.callPackage ./pkgs/minecraft {};
    mumble                    = (super.callPackages ./pkgs/mumble {
      avahi = self.avahi.override {
        withLibdnssdCompat = true;
      };
      jackSupport = true;
      pulseSupport = true;
    }).mumble;
    pjstore                   = super.callPackage ./pkgs/pjstore {};
    polybar                   = super.callPackage ./pkgs/polybar {};
    starbound                 = super.callPackage ./pkgs/starbound { inherit nonredistKey; };

    nodePackages = (super.nodePackages or {}) // import ./pkgs/nodePackages {};

    inherit (super.callPackage ./lib/extra-builders.nix {})
      writeRubyScriptBin;

    # joins the contents of a sequence of derivations
    overlay = layers: derivation {
      inherit (builtins.head layers) name system;
      inherit layers;

      coreutils = self.coreutils;
      builder = super.writeShellScript "overlay-builder" ''
        PATH=$coreutils/bin
        mkdir $out
        for layer in $layers; do
          cp -ar $layer/* $out/
          chmod -R u+w $out/
        done
      '';
    };
  };

  modules = {
    # :r!find ./modules -mindepth 2 -maxdepth 2 -type d
    imports = [
      ./modules/services/starbound
      ./modules/services/pjstore
      ./modules/configs/shell
      ./modules/configs/nvim
    ];
  };

  sshKeys = {
    dark = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFEyf3k/BubYjMNUOGlhUJ2m2/oUAGNpvWZZw2V1SmJA2WloDqmoT3ChPR9WVwpFEaxr4kH8Nc+k9Nq5qn5ndWMTMV8oz5t9N77u3hIKeGc2xQ+sz+KOvOY7pSFd0ZfASry3NTZgxdVdfrekEViw6XjCF+ab0fkJPRPkr1OmT2wz7r8JeF01UT/A0BVWKWhkG57YDbzk8+XqsakTu5SBhbGfsC3vt9iyFzVqmy+TecylercF3+3q95tkjon+DV5sMHsvMqM71Vqs3yigEUDn9XSOk8NncaVHNtMeDch82IfaJ3Da7KMc0B4fDgH8oXKuhTpjq6xxUFo9Ny2q8FyPVX dark@tetsuya"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsSVCcw/Ydi5BZec9a1wO/fucMUkdZoxEQLlWAwKI41oKh1Ca68/FQAI4zF92HzcVZN6QOZqVBkPm0fdc5JvPGc7HHfVtIDONsRgk+XFD3DllB+nSssc3JRqdSlUmii9CW6cAhEUdUpGhsTGxfSNfRyDA9p9nZCHW8kmz6l3Vx+irlBaflyP3yHvbKnbADiQTwBxIlY+yE9XXZEZ3TRUaBxla9EPbbJuNChzaVcurmcay305uBFdYZizV0SP+nZymJS64WBoBjCvJ27YXhSs/bJWnBXrjFryIJRv0RUgV6w/1C41mSecVQUiwFVV/tx1sMCqWKEgtE4T1Umemb15Y9 dark@nagumo"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpxZidbLQlFbtMhkGMY76xdfDlac6SpipG/gB0fQYJU07rOqYfZbiJgNrlgHcv6cdZAm6xbgWkcM0PZXaAsMzom5YI0bJTIXQhqls6/pNLV4TnjuuPx9W8nokalWx96PizzRQtJY8B/j8tJFJ7qXhslFg+URWaSt2HKqHiJD68bWy4YVitzjO/HXGSbHW0GBqW7UG2xgZyNo+vYp0EX6GBjVXB1PZp2hBEEOzOMMqJI4MCYOr12oLUWGokEtZZWrSqlJ1s/MpX6NOr5eMGl2fSN8wGKNsd9CUYOgbfUIqwUu0nXx5vu3GHqkdPShb1tGXciSCNT+1GXF9nzOvnJTW7 dark@sekiban"
    ];
  };
}
