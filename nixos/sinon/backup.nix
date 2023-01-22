{ ... }:

{
  services.borgbackup = {
    jobs.root = {
      paths = [
        "/etc"
        "/home"
        "/srv"
        "/var"
      ];
      exclude = [
        "/var/cache"
        "/var/keys"
      ];
      repo = "/borg/sinon";
      encryption.mode = "none";
      startAt = "daily";
      prune.keep = {
        daily = 7;
        weelky = 4;
        monthly = 12;
      };
    };

    # backup /borg to hetzner storage box
    jobs.borg = {
      paths = [ "/borg" ];
      repo = "ssh://u233274@u233274.your-storagebox.de:23/./sinon-borg";
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat /var/keys/borg-pass.key";
      };
      startAt = "daily";
      prune.keep = {
        daily = 7;
        weelky = 4;
        monthly = 12;
      };
    };
  };
}
