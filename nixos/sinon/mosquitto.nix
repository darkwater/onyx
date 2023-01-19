{ pkgs, ...}:

{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        port = 1883;
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };
}
