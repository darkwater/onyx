{ config, pkgs, lib, ... }:

let
  # "172.24.0.1/32" => "172.24.0.1"
  getAddress = addr: with builtins; let
    split = match "([0-9.]+)/[0-9.]+" addr;
  in head split;

  servers = {
    fubuki  = { ip = "172.24.0.1/24"; allowed = "172.24.0.0/24"; pubkey = "C5ge8SeMqzvXgeosOSlAmHgZpP7J1jFKjdBPRKIDgR4=";
                endpoint = "dark.red"; };
  };

  clients = {
    tetsuya   = { ip = "172.24.0.2/24";  allowed = "172.24.0.2/32";  pubkey = "TEtsuGEWh0lV4EWn+lQoMQH3IW3I1jRj2DCJ7LrlgS8="; };
    nagumo    = { ip = "172.24.0.3/24";  allowed = "172.24.0.3/32";  pubkey = "k1NKYG+l9m7P99YTL8v7DQq3RZdvbr0NiH9/YKTb4Bo="; };
    sekiban   = { ip = "172.24.0.4/24";  allowed = "172.24.0.4/32";  pubkey = "SfFjkakUk1c6e/cRquxWmt8KB/4A2Cr7/iNsa8sr4GY="; };
    seiun     = { ip = "172.24.0.5/24";  allowed = "172.24.0.5/32";  pubkey = "mZYd6TlVO48O1osndhqTgoYNBfYeTmpHfoSJefvMwiQ="; };
    sinon     = { ip = "172.24.0.6/24";  allowed = "172.24.0.6/32";  pubkey = "sinon+Lpild6N42rIPl0AY1BbQ4Z7mjoZjDrPMtVTmo="; };
    winbox    = { ip = "172.24.0.8/24";  allowed = "172.24.0.8/32";  pubkey = "gsyX8QoLLER63uaO3OwhVX5eh5HMfeNVr9Ecf0z6lW4="; };
    atsushi   = { ip = "172.24.0.9/24";  allowed = "172.24.0.9/32";  pubkey = "AtsuOp3tY+ThpXLkIKfzv/2Z/NE17rbzNvWUmB/VmCM="; };
    yukiboshi = { ip = "172.24.0.10/24"; allowed = "172.24.0.10/32"; pubkey = "YUKI+YXmPhLKhsilEXsuUx1yUuWEmov4xjA6TWp56H0="; };
    yuugure   = { ip = "172.24.0.11/24"; allowed = "172.24.0.11/32"; pubkey = "yuu+aCj3ZTdOUBlLtiDARV4IHomPstFjDFx1hu/tgk8="; };
    wslbox    = { ip = "172.24.0.12/24"; allowed = "172.24.0.12/32"; pubkey = "bbbYKmlmYupNUp7qtfPoIgkpg6Te50QfnEcaX8i5/mM="; };
    holo      = { ip = "172.24.0.13/24"; allowed = "172.24.0.13/32"; pubkey = "holo++JxghcGJ2HZ4zuqJqo64RxP9D4IKBgxdDtt21U="; };
  };

  peers = clients // servers;

  isServer = servers ? ${hostname};

  interfaceName = "wg-nv";
  wireguardPort = 51820;
  hostname = config.networking.hostName;
in {
  options = {
    dark.vpn = with lib; {
      type = mkOption {
        default = "wireguard";
        type = types.str;
      };

      address = mkOption {
        default = "";
        type = types.str;
      };
    };
  };

  config = lib.mkIf (config.dark.vpn.type == "wireguard") {
    dark.vpn.address = (getAddress peers.${hostname}.ip);

    boot.kernel.sysctl = if isServer
      then { "net.ipv4.conf.${interfaceName}.forwarding" = 1; }
      else {};

    networking.wireguard = {
      enable = true;
      interfaces.${interfaceName} = {
        ips = [ peers.${hostname}.ip ];

        listenPort = if isServer then wireguardPort else null;

        privateKeyFile = "/var/keys/wireguard";

        peers = (
          if isServer
          then (map
            (props: {
              publicKey = props.pubkey;
              allowedIPs = [ props.allowed ];
              endpoint = if props ? endpoint
                then "${props.endpoint}:${toString wireguardPort}"
                else null;
            })
            (lib.attrValues
              (lib.filterAttrs (k: v: k != hostname) peers)))
          else (map
            (props: {
              publicKey = props.pubkey;
              allowedIPs = [ props.allowed ];
              endpoint = "${props.endpoint}:${toString wireguardPort}";
              persistentKeepalive = 25;
            })
            (lib.attrValues servers)));
      };
    };

    networking = {
      firewall.allowedUDPPorts = [ wireguardPort ];
    };
  };
}
