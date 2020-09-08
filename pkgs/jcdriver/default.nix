{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pet";
  version = "0.1.0";

  src = fetchGit {
    url = https://github.com/riking/joycon;
    rev = "144b22de6c286e0a17fea23be5ed4321cb90c987";
  };

  goPackagePath = "github.com/riking/joycon/prog4/jcdriver";
  subPackages = [ "prog4/jcdriver" ];

  meta = with lib; {
    description = "JoyCon driver";
    homepage = "https://github.com/riking/joycon";
    platforms = platforms.linux;
  };
}
