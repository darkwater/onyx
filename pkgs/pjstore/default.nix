{ stdenv, rustPlatform, sqlite }:

rustPlatform.buildRustPackage rec {
  pname = "pjstore";
  version = "0.1.0";

  src = builtins.fetchGit {
    url = https://git.dark.red/darkwater/pjstore;
    rev = "86d270b4a177d492784a8d4d5e427eebcb45cde2";
  };

  buildInputs = [ sqlite ];

  cargoSha256 = "13gpa6sv02zqqph2lmqhpcxr980i4p8f65pm239rc06mjaqkyhim";
  verifyCargoDeps = true;

  RUSTC_BOOTSTRAP = 1;

  meta = with stdenv.lib; {
    description = "Store JSON objects in a SQLite database over HTTP";
    homepage = https://git.dark.red/darkwater/pjstore;
    platforms = platforms.all;
  };
}
