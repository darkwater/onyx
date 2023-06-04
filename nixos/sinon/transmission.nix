{ config, pkgs, ... }:

let
  torrentsLocation = "/data/torrents";

  user = config.services.transmission.user;
  group = config.services.transmission.group;
in {
  services.transmission = {
    enable = true;
    downloadDirPermissions = "775";
    settings = {
      download-dir = "${torrentsLocation}/_misc";
      incomplete-dir = "${torrentsLocation}/_incomplete";
      incomplete-dir-enabled = true;

      script-torrent-done-enabled = true;
      script-torrent-done-filename = pkgs.writeShellScript "torrent-done" ''
        if [[ "$TR_TORRENT_DIR" = "${torrentsLocation}/music" ]]; then
          cp -lr "$TR_TORRENT_DIR/$TR_TORRENT_NAME" /data/music/
        fi
      '';

      rpc-bind-address = "127.0.0.1";
      rpc-host-whitelist = "torrents.fbk.red";
    };
  };

  systemd.services.transmission = {
    serviceConfig.BindPaths = [ "/data" ]; # must mount the whole partition to allow hard links
    environment = {
      TRANSMISSION_WEB_HOME = "${builtins.fetchGit {
        url = "https://github.com/ronggang/transmission-web-control/";
        rev = "9fd2e5b8c7dee9da9db961ef57847ce4fe5cfc71";
      }}/src";
    };
  };

  systemd.services.normalize-torrent-permissions = {
    description = "Normalize permissions in ${torrentsLocation}";
    script = ''
      chown -R ${user}:${group} ${torrentsLocation}
      find ${torrentsLocation} -type d -exec chmod 02775 '{}' ';'
      find ${torrentsLocation} -type f -exec chmod 00664 '{}' ';'
    '';
    startAt = "08:00";
  };

  users.users = {
    dark.extraGroups = [ "transmission" ];
  };

  system.activationScripts.transmission = ''
    mkdir -p ${torrentsLocation}
    chown ${user}:${group} ${torrentsLocation}
    chmod 02775 ${torrentsLocation}
  '';

  services.nginx = let
    rpcAddress = config.services.transmission.settings.rpc-bind-address;
    rpcPort = config.services.transmission.settings.rpc-port;
  in {
    enable = true;

    virtualHosts."torrents.fbk.red" = {
      listen = [
        { addr = "0.0.0.0"; port = 443; ssl = true; }
        { addr = "0.0.0.0"; port = 80; }
      ];
      useACMEHost = "_.fbk.red";
      forceSSL = true;
      locations."/".proxyPass = "http://${rpcAddress}:${toString rpcPort}";
    };
  };
}
