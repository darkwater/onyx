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
    tetsuya   = { ip = "172.24.0.2/24";  allowed = "172.24.0.2/32";  pubkey = "g/2jyEtxSuaHVX0XKzDF02CVpp1A0KT+lJDFNgrORA0="; };
    nagumo    = { ip = "172.24.0.3/24";  allowed = "172.24.0.3/32";  pubkey = "k1NKYG+l9m7P99YTL8v7DQq3RZdvbr0NiH9/YKTb4Bo="; };
    sekiban   = { ip = "172.24.0.4/24";  allowed = "172.24.0.4/32";  pubkey = "SfFjkakUk1c6e/cRquxWmt8KB/4A2Cr7/iNsa8sr4GY="; };
    seiun     = { ip = "172.24.0.5/24";  allowed = "172.24.0.5/32";  pubkey = "mZYd6TlVO48O1osndhqTgoYNBfYeTmpHfoSJefvMwiQ="; };
    sinon     = { ip = "172.24.0.6/24";  allowed = "172.24.0.6/32";  pubkey = "TDCj/RiYn4f2ST31otuO1VnxBTbPDbIIebcESLfDPQA="; };
    winbox    = { ip = "172.24.0.8/24";  allowed = "172.24.0.8/32";  pubkey = "gsyX8QoLLER63uaO3OwhVX5eh5HMfeNVr9Ecf0z6lW4="; };
    atsushi   = { ip = "172.24.0.9/24";  allowed = "172.24.0.9/32";  pubkey = "4XolRIWE2552gsdlyhxCmIlulJQT8HVsEgRZslzuyk4="; };
    yukiboshi = { ip = "172.24.0.10/24"; allowed = "172.24.0.10/32"; pubkey = "LA5PMGAQQ+bIWdzfldCqTZOnqUO+76iuaH3+crky53E="; };
    yuugure   = { ip = "172.24.0.11/24"; allowed = "172.24.0.11/32"; pubkey = "fSZksmk+IkOK51RgGMVpfja3CZM8GPOspd1DfOEOGhM="; };
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
