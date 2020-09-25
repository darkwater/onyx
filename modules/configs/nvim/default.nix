{ config, pkgs, lib, ... }:

let
  cfg = config.onyx.configs.nvim;
in {
  options.onyx.configs.nvim = with lib; {
    enable = mkEnableOption "neovim configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (neovim.override { withNodeJs = true; })
      onyx-nvim-pack
    ];

    environment.pathsToLink = [ "/share/nvim/site/pack" ];
  };
}
