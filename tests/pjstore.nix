let
  onyx = import ../. {};
in import <nixpkgs/nixos/tests/make-test-python.nix> {
  nodes = {
    host = { config, pkgs, ... }: {
      imports = [ onyx.modules ];
      nixpkgs.overlays = [ onyx.overlay ];

      services.pjstore.enable = true;
      services.nginx = {
        enable = true;
        virtualHosts."host" = {
          locations."/".proxyPass = "http://localhost:8000/";
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];

      environment.systemPackages = with pkgs; [
        (writeShellScriptBin "add-key" ''
          ${sqlite}/bin/sqlite3 /var/lib/pjstore/prod.db <<SQL
            INSERT INTO keys VALUES (1, "$1");
          SQL
        '')
      ];
    };

    client = { config, pkgs, ... }: {
      environment.systemPackages = with pkgs; [ jq curl ];
    };
  };

  testScript = ''
    import json

    start_all()

    host.wait_for_unit("pjstore.service")
    host.succeed("add-key THISISAKEY")

    host.wait_for_unit("nginx.service")
    client.wait_for_unit("network-online.target")

    if client.succeed("curl -f http://host/THISISAKEY/foo") != "key or name not found":
        raise Exception("foo shouldn't exist")

    if (
        client.succeed("jq -nc '{a:1,b:2}' | curl -f http://host/THISISAKEY/foo -T -")
        != "ok"
    ):
        raise Exception("failed to insert data")

    if (
        client.succeed("jq -nc '{b:3,c:4}' | curl -f http://host/THISISAKEY/foo -d @-")
        != "ok"
    ):
        raise Exception("failed to update data")

    res = json.loads(client.succeed("curl -f http://host/THISISAKEY/foo"))

    if res != {"a": 1, "b": 3, "c": 4}:
        print(res)
        raise Exception("result was wrong")
  '';
}
