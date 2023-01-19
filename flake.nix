{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    shino.url = "github:darkwater/shino";
    hermes.url = "github:darkwater/hermes";
  };

  outputs = attrs @ { self, nixpkgs, ... }: {
    defaultOverlay = final: prev: {
      shino = attrs.shino;
      hermes = attrs.hermes;
    };

    packages.x86_64-linux = {
      shino = attrs.shino.defaultPackage.x86_64-linux;
      hermes = attrs.hermes.defaultPackage.x86_64-linux;
    };

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
