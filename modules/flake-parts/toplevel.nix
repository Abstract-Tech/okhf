# Top-level flake glue to get our configuration working
{
  self,
  inputs,
  lib,
  ...
}:

let
  # Combine mapAttrs' and filterAttrs
  #
  # f can return null if the attribute should be filtered out.
  mapAttrsMaybe =
    f: attrs:
    lib.pipe attrs [
      (lib.mapAttrsToList f)
      (builtins.filter (x: x != null))
      builtins.listToAttrs
    ];
  forAllNixFiles =
    dir: f:
    if builtins.pathExists dir then
      lib.pipe dir [
        builtins.readDir
        (mapAttrsMaybe (
          fn: type:
          if type == "regular" then
            let
              name = lib.removeSuffix ".nix" fn;
            in
            lib.nameValuePair name (f "${dir}/${fn}")
          else if type == "directory" && builtins.pathExists "${dir}/${fn}/default.nix" then
            lib.nameValuePair fn (f "${dir}/${fn}")
          else
            null
        ))
      ]
    else
      { };
in
{
  imports = [
    inputs.nixos-unified.flakeModules.default
  ];

  flake = {
    nixosConfigurations = forAllNixFiles "${self}/hosts" (
      fn: self.nixos-unified.lib.mkLinuxSystem { home-manager = false; } fn
    );

    nixosModules = forAllNixFiles "${self}/modules/nixos" (fn: fn);

    overlays = forAllNixFiles "${self}/overlays" (
      fn: import fn self.nixos-unified.lib.specialArgsFor.common
    );
  };
}
