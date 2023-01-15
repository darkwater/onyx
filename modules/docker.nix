{ pkgs, config, ... }:

{
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
  ];

  systemd.tmpfiles.rules = [
    "d /srv/docker       0755 root root - "
    "L /root/docker      -    -    -    - /srv/docker"
  ];
}
