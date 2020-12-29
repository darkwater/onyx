{ stdenv, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-node";
  version = "0.1.0";

  src = builtins.fetchGit {
    url = "https://github.com/flovangh/cargo-node";
    rev = "fff95338120067e16064df7c6009cdd993f5fc93";
  };

  cargoSha256 = "0pkr5m61f60hfzdqwdbr6xqrnm0g0c3a1gpgjrqk4zxfiypad8l4";
  # verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "A cargo sub command to build, run and deploy rust wasm applications as browser, electron or cordova app";
    homepage = https://github.com/flovangh/cargo-node;
    platforms = platforms.all;
  };
}
