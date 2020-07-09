{ stdenv, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "crc16";
  version = "0.1.0";

  src = builtins.fetchGit {
    url = "https://git.dark.red/darkwater/crc16";
    rev = "a7249900646123c3a6b059d26fe170dc02543967";
  };

  cargoSha256 = "13a8b4rh1s982y2987dq1p1dibdgnsf903fjizrn50pfm506i3na";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "Calculate crc16 checksum from stdin";
    homepage = https://git.dark.red/darkwater/crc16;
    platforms = platforms.all;
  };
}
