{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; },
  nonredistKey ? "",
}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    brightctl         = callPackage ./pkgs/brightctl { };
    factorio-headless = callPackage ./pkgs/factorio { };
    starbound         = callPackage ./pkgs/starbound { inherit nonredistKey; };
  };
in self
