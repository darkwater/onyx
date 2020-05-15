{ config, pkgs, lib, ... }:

let
  cfg = config.onyx.configs.nvim;
  onyx-nvim-pack = pkgs.callPackage ./pack.nix {};
in {
  options.onyx.configs.nvim = with lib; {
    enable = mkEnableOption "neovim configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      neovim onyx-nvim-pack
    ];

    environment.pathsToLink = [ "/share/nvim/site/pack" ];
  };
}
