{ callPackage }:

let
  unstable = import (builtins.fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {};

  rust-analyzer-pkgs = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/tools/rust/rust-analyzer/generic.nix";
  };
in {
  rust-analyzer = callPackage rust-analyzer-pkgs rec {
    inherit (unstable) rustPlatform;
    rev = "2020-06-22";
    version = "unstable-${rev}";
    sha256 = "1cxsdc4b1823i5dx7nvh584araqbhpj8lx3jc0cc8qgm9hdbphz8";
    cargoSha256 = "0sr85grdgb5ilmpikaf56bpwrgd1xjya9cv4l37sbd7p6lka9y4c";
    doCheck = false;
  };
}
