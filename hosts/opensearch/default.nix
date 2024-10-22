{
  flake,
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

  services.opensearch = {
    enable = true;
    settings = {
      "network.host" = "0.0.0.0";
    };
  };
}
