{ stdenv, rustPlatform, sqlite }:

rustPlatform.buildRustPackage rec {
  pname = "pjstore";
  version = "0.1.0";

  src = builtins.fetchGit {
    url = "https://github.com/darkwater/pjstore";
    rev = "86d270b4a177d492784a8d4d5e427eebcb45cde2";
  };

  buildInputs = [ sqlite ];

  cargoSha256 = "1rh1krqrrsi21zhmrpv2rq4xdwfbyx30iwcifcj875xg1k5h6qib";
  verifyCargoDeps = true;

  RUSTC_BOOTSTRAP = 1;

  meta = with stdenv.lib; {
    description = "Store JSON objects in a SQLite database over HTTP";
    homepage = https://github.com/darkwater/pjstore;
    platforms = platforms.all;
  };
}
