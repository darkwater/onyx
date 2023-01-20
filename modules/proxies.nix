{ config, lib, ... }:

{
  options.onyx.proxies = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        port = lib.mkOption {
          type = lib.types.int;
          description = "Port to proxy to.";
        };
      };
    });
    default = { };
    description = "Simple Nginx proxies to set up.";
  };

  config = lib.mkIf (config.onyx.proxies != { }) {
    services.nginx.enable = true;
    services.nginx.virtualHosts = lib.attrsets.mapAttrs
      (name: value: {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString value.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      })
      config.onyx.proxies;
  };
}
