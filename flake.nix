{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    shino.url = "github:darkwater/shino-rust";
    hermes.url = "github:darkwater/hermes";
  };

  outputs = attrs @ { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
    in
    rec {
      overlays.default = final: prev: {
        shino = attrs.shino;
        hermes = attrs.hermes;
      };

      packages.x86_64-linux = {
        shino = attrs.shino.defaultPackage.x86_64-linux;
        hermes = attrs.hermes.defaultPackage.x86_64-linux;
      };

      nixosModules.default = import modules/onyx.nix;

      nixosConfigurations.fubuki = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          modules/onyx.nix

          nixos/fubuki
          nixos/common.nix
          nixos/fbk-red-ssl.nix
          nixos/wireguard.nix

          ({ ... }: {
            onyx.hetzner.enable = true;
            networking.hostName = "fubuki";
            onyx.shell.hostnameColor = {
              fg = [ 250 250 250 ];
              bg = [ 81 114 142 ];
            };
          })
        ];
      };

      nixosConfigurations.sinon = lib.nixosSystem {
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

      summary =
        let
          packages = host:
            with lib;
            with builtins;
            concatStrings
              (lists.unique
                (sort lessThan
                  (map
                    (pkg: "  ${pkg.meta.name}\n")
                    nixosConfigurations."${host}".config.environment.systemPackages)));

          # services = host:
          #   with lib;
          #   with builtins;
          #   concatStrings
          #     (lists.unique
          #       (sort lessThan
          #         (mapAttrsToList
          #           (name: service:
          #             if service ? enable
          #               && service.enable.type.description == "boolean"
          #               && service.enable.value
          #             then
          #               let
          #                 package =
          #                   if service ? package
          #                     && service.package.type.description == "package"
          #                   then service.package.value.meta.name
          #                   else "-";
          #               in
          #               "  services.${name} pkg=${package}\n"
          #             else "")
          #           nixosConfigurations."${host}".options.services)));

          hosts = lib.concatStrings (lib.mapAttrsToList
            (host: config: ''
              ${host}:
              ${packages host}
            '')
            nixosConfigurations);
        in
        hosts;
    };
}
