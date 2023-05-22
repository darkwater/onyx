{ config, lib, pkgs, shino, hermes, ... }:

{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./mosquitto.nix
    ./spotifyd.nix
    ./sway.nix
    ./transmission.nix
  ];

  environment.systemPackages = with pkgs; [
    alacritty
    espeak-ng
    feh
    ffmpeg-full
    firefox
    maim
    mpv
    pulsemixer
    sway
    tailscale
    wayland
    wtype
    youtube-dl

    shino.defaultPackage.x86_64-linux
    hermes.defaultPackage.x86_64-linux
  ];
  
  services.tailscale.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="2548", ATTRS{idProduct}=="1002", OWNER="dark"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", OWNER="dark"
  '';

  services.rdnssd.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
    hostName = config.networking.hostName;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts."ha.fbk.red" = {
      listen = [{ addr = "0.0.0.0"; port = 443; ssl = true; }];
      onlySSL = true;
      useACMEHost = "_.fbk.red";
      locations."/" = {
        proxyPass = "http://localhost:8123";
        proxyWebsockets = true;
      };
    };

    virtualHosts."sinon.fbk.red" = {
      listen = [{ addr = "0.0.0.0"; port = 443; ssl = true; }];
      onlySSL = true;
      useACMEHost = "_.fbk.red";
      locations."/s/".alias = "/data/s/";
      locations."/e3/".alias = "/data/e3-nv/public/";
      locations."/anime/".alias = "/data/anime/";
      locations."/torrents/".alias = "/data/torrents/";
    };
  };
}
