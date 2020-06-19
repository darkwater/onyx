{ callPackage }:

let
  unstable = import (builtins.fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {};

  rust-analyzer-pkgs = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/tools/rust/rust-analyzer/generic.nix";
  };
in {
  rust-analyzer = callPackage rust-analyzer-pkgs rec {
    inherit (unstable) rustPlatform;
    rev = "2020-06-15";
    version = "unstable-${rev}";
    sha256 = "1qwkhzhgw6sap6vf5ilzr96a88r3snfrf3fcfkzw3n67j7lvsprf";
    cargoSha256 = "0gcgfgrrjxzcgdci709dvx3904sbqx03w4pkbj89kk44j65cdzsy";
    doCheck = false;
  };
}
