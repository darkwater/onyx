{ stdenv, rustPlatform, runCommand }:

let
  src = builtins.fetchGit {
    url = "https://github.com/japaric/itm-tools";
    rev = "e94155e44019d893ac8e6dab51cc282d344ab700";
  };
in rustPlatform.buildRustPackage {
  pname = "itm-tools";
  version = "0.1.0";

  # stinky upstream doesn't include a lockfile, so we supply our own
  src = runCommand "itm-tools-src" {} ''
    cp -r ${src} $out
    chmod +w $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';

  cargoSha256 = "1vfc65wsy6hvhwxcnz3yl6r6qn65h8d3wikn83divwfj0sv6dahy";

  meta = with stdenv.lib; {
    description = "Tools for analyzing ITM traces.";
    homepage = https://github.com/japaric/itm-tools;
    platforms = platforms.all;
  };
}
