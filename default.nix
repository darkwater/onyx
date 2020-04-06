{ nonredistKey ? "" }:

{
  overlay = self: super: {
    brightctl                 = super.callPackage ./pkgs/brightctl {};
    cargo-node                = super.callPackage ./pkgs/cargo-node {};
    factorio-headless         = super.callPackage ./pkgs/factorio {};
    starbound                 = super.callPackage ./pkgs/starbound { inherit nonredistKey; };
    minecraft-server-snapshot = super.callPackage ./pkgs/minecraft {};

    nodePackages = (super.nodePackages or {}) // import ./pkgs/nodePackages {};

    inherit (super.callPackage ./lib/extra-builders.nix {})
      writeRubyScriptBin;
  };

  modules = {
    # :r!find ./modules -mindepth 2 -type d
    imports = [
      ./modules/services/starbound
      ./modules/configs/shell
    ];
  };

  sshKeys = {
    dark = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzbL/PlKzLtFpKJM679rQWz41rhsmPhP/tqVKPQHJt7ribYAWSkXwLlgGj8ZmHXDrJdrcMETokebROlWR9rAN14IK+CVBk1elwLLpbTXUEyeUmLvYupPFnjMym6EuJYMuh06rhhHfDdUmGXfBSuiHlrEVvsByEdiSERIrJbJEgB8tpFT4EkFFIRuA6EhojJOOZJ/8s438QhVcA/lugPt4O0/7fOF0VpKyewxBLwCdpGEl3GwPSDL+x6llZZRH4F3ph3pPJ4dvZiqSc0q4Kk39OKms0bca+0+Nnyr5b+mNeGGQACrkyxAUJE1A9Mh5eg+iXnC2hBtzTdOoEV/FYL3k1 dark@novaember"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFEyf3k/BubYjMNUOGlhUJ2m2/oUAGNpvWZZw2V1SmJA2WloDqmoT3ChPR9WVwpFEaxr4kH8Nc+k9Nq5qn5ndWMTMV8oz5t9N77u3hIKeGc2xQ+sz+KOvOY7pSFd0ZfASry3NTZgxdVdfrekEViw6XjCF+ab0fkJPRPkr1OmT2wz7r8JeF01UT/A0BVWKWhkG57YDbzk8+XqsakTu5SBhbGfsC3vt9iyFzVqmy+TecylercF3+3q95tkjon+DV5sMHsvMqM71Vqs3yigEUDn9XSOk8NncaVHNtMeDch82IfaJ3Da7KMc0B4fDgH8oXKuhTpjq6xxUFo9Ny2q8FyPVX dark@dark-desktop"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsSVCcw/Ydi5BZec9a1wO/fucMUkdZoxEQLlWAwKI41oKh1Ca68/FQAI4zF92HzcVZN6QOZqVBkPm0fdc5JvPGc7HHfVtIDONsRgk+XFD3DllB+nSssc3JRqdSlUmii9CW6cAhEUdUpGhsTGxfSNfRyDA9p9nZCHW8kmz6l3Vx+irlBaflyP3yHvbKnbADiQTwBxIlY+yE9XXZEZ3TRUaBxla9EPbbJuNChzaVcurmcay305uBFdYZizV0SP+nZymJS64WBoBjCvJ27YXhSs/bJWnBXrjFryIJRv0RUgV6w/1C41mSecVQUiwFVV/tx1sMCqWKEgtE4T1Umemb15Y9 dark@dark-laptop"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/H18uxg8tLys/hmJS7tAtpnHBRVxHnpVreDS/ZWXLSTw+u7hAkjubzftONLAhJ8y8p5EHgxeR0hHlZS08ziBk9XXH3NT0gtrZBthKP5KFMku87UgcFrQQkQp8QykKbWI7Vr2KnKbwnjsar6io8+/xfqRH7gIjNTDyIi+3Uds25p10t6m7m9u3/4c8jVfBeN7y+rcNKvSfebfk9cLZFYSp3JrfW+q6//r4NxvFrQzNqDb4qr51pJY7Sw23U7k3LU3fA1G6J6xCr6D8ic9JiLsArgKYDqnnGTqLS26U5Yh8pLFjdeM8lt7ECxU+v7vFdpbWY2gPzZswCVT4KnZaYUir dark@sekiban"
    ];
  };
}
