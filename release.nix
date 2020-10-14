let
  onyx = (import ./default.nix {});

  pkgs     = import <nixpkgs> { config.allowUnfree = true; };
  overlaid = import <nixpkgs> { config.allowUnfree = true; overlays = [ onyx.overlay ]; };

  emptyOverlay = onyx.overlay { inherit (overlaid) callPackage; } {};

  # shells aren't supposed to be built, but we just want them for their dependencies
  wrapShell = shell: shell.overrideAttrs (_: { nobuildPhase = "echo $PATH > $out"; });
in
  with builtins;
  with pkgs.lib;
  pkgs.lib.getAttrs (builtins.attrNames emptyOverlay) overlaid // {
    nodePackages = getAttrs
      (attrNames emptyOverlay.nodePackages)
      overlaid.nodePackages;

    vimPlugins = getAttrs
      (attrNames emptyOverlay.vimPlugins)
      overlaid.vimPlugins;

    pjstore-test = import tests/pjstore.nix;

    shell-rust-2020-09     = wrapShell (overlaid.onyx-shells.rust { nightly = "2020-09"; });
    shell-rust-2020-09-emb = wrapShell (overlaid.onyx-shells.rust { nightly = "2020-09"; embedded = true; });
  }
