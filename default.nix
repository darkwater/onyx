{ nonredistKey ? "" }:

{
  overlay = self: super: {
    brightctl         = super.callPackage ./pkgs/brightctl { };
    factorio-headless = super.callPackage ./pkgs/factorio { };
    starbound         = super.callPackage ./pkgs/starbound { inherit nonredistKey; };
  };

  modules = {
    # :r!find modules -mindepth 2 -type d
    imports = [
      modules/services/starbound
    ];
  };
}
