# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, pkgs, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    ./networking.nix
  ];

  services.mysql = {
    enable = true;
    package = pkgs.percona-server_8_0;
  };
}
