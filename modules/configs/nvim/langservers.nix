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
    rev = "2020-06-01";
    version = "unstable-${rev}";
    sha256 = "0chm47mrd4hybhvzn4cndq2ck0mj948mm181p1i1j1w0ms7zk1fg";
    cargoSha256 = "0yaz50f7hirlcs8bxc5dh170lch9l1gscwayan71k3pz23wkvlzs";
    doCheck = false;
  };
}
