{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    shino.url = "github:darkwater/shino";
    hermes.url = "github:darkwater/hermes";
  };

  outputs = attrs @ { self, nixpkgs, ... }: {
    overlays.default = final: prev: {
      shino = attrs.shino;
      hermes = attrs.hermes;
    };

    packages.x86_64-linux = {
      shino = attrs.shino.defaultPackage.x86_64-linux;
      hermes = attrs.hermes.defaultPackage.x86_64-linux;
    };

    nixosModules.default = import modules/onyx.nix;

    nixosConfigurations.sinon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        modules/onyx.nix

        nixos/sinon
        nixos/common.nix
        nixos/fbk-red-ssl.nix
        nixos/wireguard.nix

        ({ ... }: {
          networking.hostName = "sinon";
          onyx.shell.hostnameColor = {
            fg = [ 196 252 227 ];
            bg = [ 48 42 3 ];
          };
        })
      ];
    };
  };
}
