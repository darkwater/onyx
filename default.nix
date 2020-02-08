{ nonredistKey ? "" }:

{
  overlay = self: super: {
    brightctl                 = super.callPackage ./pkgs/brightctl { };
    factorio-headless         = super.callPackage ./pkgs/factorio { };
    starbound                 = super.callPackage ./pkgs/starbound { inherit nonredistKey; };
    minecraft-server-snapshot = super.callPackage ./pkgs/minecraft { };
  };

  modules = {
    # :r!find modules -mindepth 2 -type d
    imports = [
      modules/services/starbound
    ];
  };
}
