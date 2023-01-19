{ config, ... }:

{
  security.acme.certs."_.fbk.red" = {
    domain = "*.fbk.red";
    group = config.services.nginx.group;
    dnsProvider = "hetzner";
    credentialsFile = "/var/keys/hetzner-dns-api.key";
  };
}
