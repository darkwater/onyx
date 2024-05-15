{ config, ... }:

{
  security.acme.certs."fbk.red" = {
    extraDomainNames = ["*.fbk.red" "*.${config.networking.hostName}.fbk.red"];
    group = config.services.nginx.group;
    dnsProvider = "hetzner";
    credentialsFile = "/var/keys/hetzner-dns-api.key";
  };
}
