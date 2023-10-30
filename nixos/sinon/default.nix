{ config, lib, pkgs, ... }:

{
  imports = [
    ./backup.nix
    ./hardware.nix
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
  ];

  services.tailscale.enable = true;

  services.flatpak.enable = true;

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

    virtualHosts."actual.fbk.red" = {
      onlySSL = true;
      useACMEHost = "_.fbk.red";
      locations."/" = {
        proxyPass = "http://localhost:1357";
        proxyWebsockets = true;
      };
    };

    virtualHosts."ha.fbk.red" = {
      onlySSL = true;
      useACMEHost = "_.fbk.red";
      locations."/" = {
        proxyPass = "http://localhost:8123";
        proxyWebsockets = true;
      };
    };

    virtualHosts."sinon.fbk.red" = {
      onlySSL = true;
      useACMEHost = "_.fbk.red";
      locations."/s/".alias = "/data/s/";
      locations."/e3/".alias = "/data/e3-nv/public/";
      locations."/anime/".alias = "/data/anime/";
      locations."/torrents/".alias = "/data/torrents/";
    };

    virtualHosts."tetsu.fbk.red" = {
      onlySSL = true;
      useACMEHost = "_.fbk.red";
      locations."/" = {
        proxyPass = "http://localhost:5352";
        proxyWebsockets = true;
      };
    };

    virtualHosts."syncthing.sinon.fbk.red" = {
      onlySSL = true;
      useACMEHost = "_.sinon.fbk.red";
      locations."/" = {
        proxyPass = "http://localhost:8384";
        proxyWebsockets = true;
        extraConfig = ''
          allow 172.24.0.0/24;
          deny all;
        '';
      };
    };
  };
}
