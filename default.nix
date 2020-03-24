{ nonredistKey ? "" }:

{
  overlay = self: super: {
    brightctl                 = super.callPackage ./pkgs/brightctl {};
    cargo-node                = super.callPackage ./pkgs/cargo-node {};
    factorio-headless         = super.callPackage ./pkgs/factorio {};
    starbound                 = super.callPackage ./pkgs/starbound { inherit nonredistKey; };
    minecraft-server-snapshot = super.callPackage ./pkgs/minecraft {};

    nodePackages = (super.nodePackages or {}) // import ./pkgs/nodePackages {};
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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFEyf3k/BubYjMNUOGlhUJ2m2/oUAGNpvWZZw2V1SmJA2WloDqmoT3ChPR9WVwpFEaxr4kH8Nc+k9Nq5qn5ndWMTMV8oz5t9N77u3hIKeGc2xQ+sz+KOvOY7pSFd0ZfASry3NTZgxdVdfrekEViw6XjCF+ab0fkJPRPkr1OmT2wz7r8JeF01UT/A0BVWKWhkG57YDbzk8+XqsakTu5SBhbGfsC3vt9iyFzVqmy+TecylercF3+3q95tkjon+DV5sMHsvMqM71Vqs3yigEUDn9XSOk8NncaVHNtMeDch82IfaJ3Da7KMc0B4fDgH8oXKuhTpjq6xxUFo9Ny2q8FyPVX dark@dark-desktop"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsSVCcw/Ydi5BZec9a1wO/fucMUkdZoxEQLlWAwKI41oKh1Ca68/FQAI4zF92HzcVZN6QOZqVBkPm0fdc5JvPGc7HHfVtIDONsRgk+XFD3DllB+nSssc3JRqdSlUmii9CW6cAhEUdUpGhsTGxfSNfRyDA9p9nZCHW8kmz6l3Vx+irlBaflyP3yHvbKnbADiQTwBxIlY+yE9XXZEZ3TRUaBxla9EPbbJuNChzaVcurmcay305uBFdYZizV0SP+nZymJS64WBoBjCvJ27YXhSs/bJWnBXrjFryIJRv0RUgV6w/1C41mSecVQUiwFVV/tx1sMCqWKEgtE4T1Umemb15Y9 dark@dark-laptop"
    ];
  };
}
