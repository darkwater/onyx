{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./sway.nix
  ];

  environment.systemPackages = with pkgs; [
    alacritty baobab espeak-ng feh ffmpeg-full firefox graphviz gtk2fontsel
    gucharmap inotify-tools lm_sensors maim mpv mumble pulsemixer rofi ruby
    slop socat sway wayland xclip xdotool xorg.xwininfo youtube-dl
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  services.rdnssd.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;

  services.nginx = {
    enable = true;

    virtualHosts."ha.fbk.red" = {
      listen = [ { addr = config.dark.vpn.address; port = 443; ssl = true; } ];
      onlySSL = true;
      useACMEHost = "_.fbk.red";
      locations."/" = {
        proxyPass = "http://localhost:8123";
        proxyWebsockets = true;
      };
    };

    virtualHosts."sinon.fbk.red" = {
      listen = [ { addr = config.dark.vpn.address; port = 443; ssl = true; } ];
      onlySSL = true;
      useACMEHost = "_.fbk.red";
      locations."/s/".alias = "/data/s/";
      locations."/e3/".alias = "/data/e3-nv/public/";
      locations."/anime/".alias = "/data/anime/";
      locations."/torrents/".alias = "/data/torrents/";
    };
  };
}
