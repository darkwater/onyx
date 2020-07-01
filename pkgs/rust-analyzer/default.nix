{ callPackage, rustPlatform }:

let
  inherit (import ../../. {}) unstable;
in callPackage ./generic.nix rec {
  inherit (unstable) rustPlatform;
  rev = "2020-06-29";
  version = "unstable-${rev}";
  sha256 = "1cxsdc4b1823i5dx7nvh584araqbhpj8lx3jc0cc8qgm9hdbphz8";
  cargoSha256 = "1dcvnn1gh8ksb1gbjhp1y3fgqs8by8m45h85fhgm2hicvawjliyn";
  doCheck = false;
}
