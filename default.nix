{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; }
}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    brightctl         = callPackage ./pkgs/brightctl { };
    factorio-headless = callPackage ./pkgs/factorio { };
  };
in self
