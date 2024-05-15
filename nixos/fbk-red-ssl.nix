{ config, ... }:

{
  security.acme.certs."fbk.red" = {
    domain = "fbk.red";
    group = config.services.nginx.group;
    dnsProvider = "hetzner";
    credentialsFile = "/var/keys/hetzner-dns-api.key";
  };

  security.acme.certs."_.fbk.red" = {
    domain = "*.fbk.red";
    group = config.services.nginx.group;
    dnsProvider = "hetzner";
    credentialsFile = "/var/keys/hetzner-dns-api.key";
  };

  security.acme.certs."_.${config.networking.hostName}.fbk.red" = {
    domain = "*.${config.networking.hostName}.fbk.red";
    group = config.services.nginx.group;
    dnsProvider = "hetzner";
    credentialsFile = "/var/keys/hetzner-dns-api.key";
  };
}
