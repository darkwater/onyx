{ stdenv, fetchurl, jre }:
stdenv.mkDerivation {
  pname = "minecraft-server";
  version = "1.16-20w08a";

  src = fetchurl {
    url    = "https://launcher.mojang.com/v1/objects/b46203f7cc23ec786710fdcf6f369935cf92dabb/server.jar";
    sha256 = "0x4fm619fyn3lhyr29xaijlkhyfi4b5r7d5g8k9qld4kwz9mmhzy";
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
