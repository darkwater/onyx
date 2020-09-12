with import <nixpkgs> {
  overlays = [ (import ./default.nix {}).overlay ];
};

let
  build = (writeShellScriptBin "build" ''
    pkg="$1"
    shift
    nix-build -E "
      with import <nixpkgs> {
        overlays = [ (import ./default.nix {}).overlay ];
      };
      $pkg
    " "$@"
  '');
in stdenv.mkDerivation {
  name = "onyx_overlay_shell";
  buildInputs = [
    build

    (writeShellScriptBin "onvim" ''
      result="$(${build}/bin/build onyx-nvim-pack --no-out-link)"
      exec ${neovim}/bin/nvim --cmd "set packpath=$result/share/nvim/site" "$@"
    '')
  ];

  shellHook = ''
    echo "commands:"
    echo "  build <pkg>  - build the specified package"
    echo "  onvim        - run nvim with onyx configuration"
  '';
}
