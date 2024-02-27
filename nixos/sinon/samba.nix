{ config, lib, pkgs, ... }:

{
  services.samba = {
    enable = true;
    package = pkgs.samba4Full;
    securityType = "user";
    invalidUsers = [ "root" ];
    extraConfig = ''
      workgroup = DARKNESS
      server string = sinon
      server role = standalone server
    '';
    shares = {
      data = {
        path = "/data/";
        "guest ok" = "no";
        public = "yes";
        writable = "yes";
        printable = "no";
        browseable = "yes";
        "read only" = "no";
        comment = "sinon data";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    discovery = true;
    extraOptions = [
      "--verbose"
    ];
  };
}
