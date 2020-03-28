with import <nixpkgs> {
  overlays = [ (import ./default.nix {}).overlay ];
};
stdenv.mkDerivation {
  name = "onyx_overlay_shell";
  buildInputs = [
    (writeShellScriptBin "build" ''
      nix-build -E "
        with import <nixpkgs> {
          overlays = [ (import ./default.nix {}).overlay ];
        };
        $1
      "
    '')
  ];
}
