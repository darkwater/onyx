{ config, lib, pkgs, ... }:

let
  cfg = config.onyx.docker;
in
{
  options.onyx.docker = {
    enable = lib.mkEnableOption "onyx docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
      daemon.settings = {
        log-driver = "json-file";
        log-opts = {
          "max-size" = "10m";
          "max-file" = "3";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      docker-compose
      dive
    ];

    systemd.tmpfiles.rules = [
      "d /srv/docker       0755 root root - "
      "L /root/docker      -    -    -    - /srv/docker"
    ];
  };
}
