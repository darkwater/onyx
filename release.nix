let
  onyx = (import ./default.nix {});
  pkgs = import <nixpkgs> { config.allowUnfree = true; };
in {
  onyx-nvim-pack = (pkgs.callPackage ./modules/configs/nvim/pack.nix {});
}
// (onyx.overlay {} pkgs)
