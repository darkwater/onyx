{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = attrs @ { self, nixpkgs, ... }: {
    nixosConfigurations.sinon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ({...}: { networking.hostName = "sinon"; })
        modules/sinon
        modules/common.nix

        modules/docker.nix
        modules/fbk-red-ssl.nix
        modules/mosquitto.nix
        modules/shell.nix
        modules/spotifyd.nix
        modules/transmission.nix
        modules/wireguard.nix
      ] ;
    };
  };
}
