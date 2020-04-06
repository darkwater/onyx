{ ruby, writeTextFile }:

{
  writeRubyScriptBin = name: text:
    writeTextFile {
      inherit name;
      executable = true;
      destination = "/bin/${name}";
      text = ''
        #!${ruby}/bin/ruby
        ${text}
        '';
      checkPhase = ''
        ${ruby}/bin/ruby -c $out/bin/${name}
      '';
    };
}
