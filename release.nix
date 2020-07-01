let
  onyx = (import ./default.nix {});
  emptyOverlay = onyx.overlay {} {};

  pkgs     = import <nixpkgs> { config.allowUnfree = true; };
  overlaid = import <nixpkgs> { config.allowUnfree = true; overlays = [ onyx.overlay ]; };
in
  pkgs.lib.getAttrs (builtins.attrNames emptyOverlay) overlaid
