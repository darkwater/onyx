{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pjstore;
in {
  options = {
    services.pjstore = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "If enabled, start the pjstore server.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.pjstore = {
      description     = "pjstore service user";
      home            = "/var/lib/pjstore";
      createHome      = true;
    };

    systemd.services.pjstore = {
      description = "Simple JSON database over HTTP";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network-online.target "];

      serviceConfig = {
        Type      = "simple";
        User      = "pjstore";
        ExecStart = "${pkgs.pjstore}/bin/pjstore /var/lib/pjstore/prod.db";
      };
    };
  };
}
