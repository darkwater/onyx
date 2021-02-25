{ stdenv, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "crc16";
  version = "0.1.0";

  src = builtins.fetchGit {
    url = "https://github.com/darkwater/crc16";
    rev = "a7249900646123c3a6b059d26fe170dc02543967";
  };

  cargoSha256 = "02hhnv2k90ka9r10y48x252d3di9nc3hm2z8860n8jgc8yw60jra";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "Calculate crc16 checksum from stdin";
    homepage = https://github.com/darkwater/crc16;
    platforms = platforms.all;
  };
}
