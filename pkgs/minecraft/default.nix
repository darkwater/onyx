{ stdenv, fetchurl, jre }:
stdenv.mkDerivation {
  pname = "minecraft-server";
  version = "1.16-20w07a";

  src = fetchurl {
    url    = "https://launcher.mojang.com/v1/objects/3944965e1621a5ccbe99292479cc62e07bccd611/server.jar";
    sha256 = "1xajd2hjrzv5jz9aqbsif46azib8vm2fwwk7958z5dvd5p7z1phn";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/minecraft
    cp -v $src $out/lib/minecraft/server.jar

    cat > $out/bin/minecraft-server << EOF
    #!/bin/sh
    exec ${jre}/bin/java \$@ -jar $out/lib/minecraft/server.jar nogui
    EOF

    chmod +x $out/bin/minecraft-server
  '';

  phases = "installPhase";

  meta = {
    description = "Minecraft Server";
    homepage    = "https://minecraft.net";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice tomberek costrouc ];
  };
}
