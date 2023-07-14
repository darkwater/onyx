{ config, lib, pkgs, shino, hermes, ... }:

{
  services.nginx = {
    enable = true;

    virtualHosts."dark.red" = {
      listen = [{ addr = "0.0.0.0"; port = 443; ssl = true; }];
      forceSSL = true;
      locations."/".root = "/srv/http/dark.red/public/";
      locations."/s/" = {
        proxyPass = "https://sinon.fbk.red/s/legacy/8f9453";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
      };
    };

    virtualHosts."s.dark.red" = {
      listen = [{ addr = "0.0.0.0"; port = 443; ssl = true; }];
      forceSSL = true;
      locations."/" = {
        proxyPass = "https://sinon.fbk.red/s/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
      };
      locations."/anime/" = {
        proxyPass = "https://sinon.fbk.red/anime/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
      };
      locations."/torrents/" = {
        proxyPass = "https://sinon.fbk.red/torrents/";
        extraConfig = "proxy_set_header Host sinon.fbk.red;";
      };
    };

    virtualHosts."httpbin.dark.red" = {
      listen = [{ addr = "0.0.0.0"; port = 443; ssl = true; }];
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:6550";
    };

    virtualHosts."pass.fbk.red" = {
      listen = [{ addr = "172.24.0.1"; port = 443; ssl = true; }];
      onlySSL = true;
      locations."/".proxyPass = "http://localhost:4800";
    };
  };
}
