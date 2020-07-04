{ stdenv, fetchFromBitbucket, cmake, pkg-config, boost }:

stdenv.mkDerivation {
  name = "unvpk";
  src = fetchFromBitbucket {
    owner = "panzi";
    repo = "unvpk";
    rev = "30afabe43347d4ea0b73efe309b4adc7bd024450";
    hash = "sha256:1njmzvqxqnx61zqm30bmhhkapcciia708inv96dbsrlwybzx2f0s";
  };

  buildInputs = [ cmake pkg-config boost ];

  buildPhase = ''
    cmake .
    make
  '';

  installPhase = ''
    install -Dm 755 unvpk/unvpk $out/bin/unvpk
  '';
}
