let
  onyx = (import ./default.nix {});

  pkgs     = import <nixpkgs> { config.allowUnfree = true; };
  overlaid = import <nixpkgs> { config.allowUnfree = true; overlays = [ onyx.overlay ]; };

  emptyOverlay = onyx.overlay { inherit (overlaid) callPackage; } {};
in
  pkgs.lib.getAttrs (builtins.attrNames emptyOverlay) overlaid // {
    nodePackages = pkgs.lib.getAttrs
      (builtins.attrNames emptyOverlay.nodePackages)
      overlaid.nodePackages;

    vimPlugins = pkgs.lib.getAttrs
      (builtins.attrNames emptyOverlay.vimPlugins)
      overlaid.vimPlugins;

    pjstore-test = import tests/pjstore.nix;
  }
