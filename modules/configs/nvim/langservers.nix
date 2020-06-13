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
    rev = "2020-06-08";
    version = "unstable-${rev}";
    sha256 = "0ywwsb717d1rwcy2yij58sj123pan0fb80sbsiqqprcln0aaspip";
    cargoSha256 = "1c6rmrhx7q4qcanr26yzlwc2rp1hh55m80jn56hy6hfcvwcdaij4";
    doCheck = false;
  };
}
