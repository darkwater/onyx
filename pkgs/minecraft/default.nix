{ stdenv, fetchurl, jre }:
stdenv.mkDerivation {
  pname = "minecraft-server";
  version = "1.16-20w06a";

  src = fetchurl {
    url    = "https://launcher.mojang.com/v1/objects/9b74998642553efe0e4d1aa079dc737b3e4cdc13/server.jar";
    sha256 = "1qg7dk5vkqhkn7njjq9prvlvb0haw7k0gzjpkp9qfvmpbwcygpnb";
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
