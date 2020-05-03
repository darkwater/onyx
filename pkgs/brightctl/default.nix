{ stdenv, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "brightctl";
  version = "0.1.0";

  src = builtins.fetchGit {
    url = https://github.com/darkwater/brightctl;
    rev = "89298ab8c313689ca92bd9beae8856576f16a7c3";
  };

  cargoSha256 = "0jacm96l1gw9nxwavqi1x4669cg6lzy9hr18zjpwlcyb3qkw9z7f";
  verifyCargoDeps = false;

  meta = with stdenv.lib; {
    description = "Change display backlight brightness with fade";
    homepage = https://github.com/darkwater/brightctl;
    platforms = platforms.all;
  };
}
