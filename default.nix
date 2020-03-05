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
      ./modules/services/starbound
    ];
  };

  configs = {
    shell = import ./configs/shell;
  };

  sshKeys = {
    dark = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzbL/PlKzLtFpKJM679rQWz41rhsmPhP/tqVKPQHJt7ribYAWSkXwLlgGj8ZmHXDrJdrcMETokebROlWR9rAN14IK+CVBk1elwLLpbTXUEyeUmLvYupPFnjMym6EuJYMuh06rhhHfDdUmGXfBSuiHlrEVvsByEdiSERIrJbJEgB8tpFT4EkFFIRuA6EhojJOOZJ/8s438QhVcA/lugPt4O0/7fOF0VpKyewxBLwCdpGEl3GwPSDL+x6llZZRH4F3ph3pPJ4dvZiqSc0q4Kk39OKms0bca+0+Nnyr5b+mNeGGQACrkyxAUJE1A9Mh5eg+iXnC2hBtzTdOoEV/FYL3k1 dark@novaember"
    ];
  };
}
