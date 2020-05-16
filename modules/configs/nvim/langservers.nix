{ callPackage }:

let
  unstable = import (builtins.fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {};

  rust-analyzer-pkgs = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixpkgs/3ea54e69727b0195f25a2be909ae821223621a64/"
        + "pkgs/development/tools/rust/rust-analyzer/generic.nix";
    sha256 = "1ji6z6g0pzddh68yznbm2qk37g8sw2v60qsbhv1135sldbwf0y8z";
  };
in {
  rust-analyzer = callPackage rust-analyzer-pkgs rec {
    inherit (unstable) rustPlatform;
    rev = "2020-05-11";
    version = "unstable-${rev}";
    sha256 = "07sm3kqqva2jw41hb3smv3h3czf8f5m3rsrmb633psb1rgbsvmii";
    cargoSha256 = "1x1nkaf10lfa9xhkvk2rsq7865d9waxw0i4bg5kwq8kz7n9bqm90";
    doCheck = false;
  };
}
