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

  virtualisation.oci-containers.containers = {
    mongodb = {
      image = "mongo:4.4";
      autoStart = true;
      ports = ["10.0.0.3:27017:27017"];
      volumes = [
        "/var/db/mongodb:/data/db"
      ];
    };
  };
}
