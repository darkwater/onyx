{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    factorio-headless = callPackage ./pkgs/games/factorio { };
  };
in self
