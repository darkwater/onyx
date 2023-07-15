{ config, lib, pkgs, shino, hermes, ... }:

{
  services.nginx = {
    enable = true;

    virtualHosts."dark.red" = {
      default = true;
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:3000";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
      locations."/api/v1/streaming" = {
        proxyPass = "http://localhost:4000";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
      locations."/s/" = {
        proxyPass = "https://sinon.fbk.red/s/legacy/8f9453";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
        recommendedProxySettings = true;
      };
    };

    virtualHosts."s.dark.red" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "https://sinon.fbk.red/s/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
        recommendedProxySettings = true;
      };
      locations."/anime/" = {
        proxyPass = "https://sinon.fbk.red/anime/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
        recommendedProxySettings = true;
      };
      locations."/torrents/" = {
        proxyPass = "https://sinon.fbk.red/torrents/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
        recommendedProxySettings = true;
      };
    };

    virtualHosts."httpbin.dark.red" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://localhost:6550";
    };

    virtualHosts."pass.fbk.red" = {
      listen = [{ addr = "172.24.0.1"; port = 443; ssl = true; }];
      onlySSL = true;
      useACMEHost = "_.fbk.red";
      locations."/".proxyPass = "http://localhost:4800";
    };
  };
}
