{
  flake,
  pkgs,
  lib,
  ...
}:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    inputs.srvos.nixosModules.server
    inputs.srvos.nixosModules.mixins-terminfo
    inputs.srvos.nixosModules.hardware-hetzner-cloud
    inputs.disko.nixosModules.disko
    inputs.colmena.nixosModules.deploymentOptions
    ./core.nix
    ./disk.nix
    ./users.nix
    ./acme.nix
    # ./secrets.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";
}