{ inputs, ... }:

{
  imports = [
    inputs.devshell.flakeModule
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    { inputs', pkgs, ... }:
    {
      treefmt = {
        programs.nixfmt.enable = true;
        flakeFormatter = true;
        projectRootFile = "flake.nix";
      };
      devshells.default = {
        commands = [
          { package = pkgs.nix; }
          { package = pkgs.nixos-rebuild; }
          { package = pkgs.hcloud; }
          { package = inputs'.agenix-rekey.packages.default; }
          { package = inputs'.nixos-anywhere.packages.nixos-anywhere; }
        ];
      };
    };
}
