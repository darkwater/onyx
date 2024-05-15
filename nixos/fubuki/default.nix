{ config, lib, pkgs, shino, hermes, ... }:

{
  services.murmur = {
    enable = true;
    registerName = "Fubuki";
    welcometext = "welcome to snowcloud";
    bandwidth = 320 * 1024;
  };

  services.nginx = {
    enable = true;

    virtualHosts."novaember.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/".root = "/srv/http/novaember.com/public/";
      locations."/s/" = {
        proxyPass = "https://sinon.fbk.red/s/legacy/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
        recommendedProxySettings = false;
      };
    };

    virtualHosts."dark.red" = {
      default = true;
      forceSSL = true;
      enableACME = true;
      locations."/".root = "/srv/http/dark.red/public/";
      locations."/s/" = {
        proxyPass = "https://sinon.fbk.red/s/legacy/8f9453/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
        recommendedProxySettings = false;
      };
    };

    virtualHosts."fbk.red" = {
      default = true;
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:5916";
        recommendedProxySettings = false;
      };
    };

    virtualHosts."s.dark.red" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "https://sinon.fbk.red/s/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
        recommendedProxySettings = false;
      };
      locations."/anime/" = {
        proxyPass = "https://sinon.fbk.red/anime/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
        recommendedProxySettings = false;
      };
      locations."/torrents/" = {
        proxyPass = "https://sinon.fbk.red/torrents/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
        recommendedProxySettings = false;
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
      locations."/" = {
        proxyPass = "http://localhost:4800";
        extraConfig = ''
          allow 172.24.0.0/24;
          deny all;
        '';
      };
    };

    virtualHosts."dynmap.dark.red" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://sinon.fbk.red:3667";
        proxyWebsockets = true;
      };
    };

    virtualHosts."bluemap.dark.red" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://sinon.fbk.red:8100";
        proxyWebsockets = true;
      };
    };
  };
}
