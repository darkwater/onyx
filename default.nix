{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; }
}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    factorio-headless = callPackage ./pkgs/games/factorio { };
  };
in self
