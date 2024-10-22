{
  flake,
  config,
  pkgs,
  ...
}:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
  ];

  services.redis.servers.openedx = {
    enable = true;
    bind = "0.0.0.0";
    port = 6379;
    requirePassFile = config.age.secrets.redis.path;
  };
}
