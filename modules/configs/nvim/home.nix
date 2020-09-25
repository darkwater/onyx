{ config, pkgs, lib, ... }:

let
  cfg = config.onyx.configs.nvim;
in {
  options.onyx.configs.nvim = with lib; {
    enable = mkEnableOption "neovim configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ (pkgs.neovim.override { withNodeJs = true; }) ];
    home.file.".local/share/nvim/site/pack/onyx".source = pkgs.onyx-nvim-pack;
  };
}
