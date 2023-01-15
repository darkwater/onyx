{ config, pkgs, ... }:

{
  systemd.user.services.spotifyd = let
    config = pkgs.writeText "spotifyd-config" ''
      [global]
      bitrate = 320
      use_mpris = false
      device_name = "sinon"
      device_type = "speaker"
      backend = "pulseaudio"
    '';
  in {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "sound.target" ];
    description = "spotifyd, a Spotify playing daemon";
    serviceConfig = {
      ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon --cache-path=\${HOME}/.cache/spotifyd --config-path=${config}";
      Restart = "always";
      RestartSec = 12;
    };
  };
}
