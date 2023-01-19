{ ... }:

{
  onyx.shell.defaultUser = "dark";

  users.users.dark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = import ../ssh-keys.nix;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = import ../ssh-keys.nix;
  };

  services.nginx.enable = true;
  security.acme.defaults.email = "dark@dark.red";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
