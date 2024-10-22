{
  flake,
  config,
  lib,
  ...
}:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    self.nixosModules.k3s
    self.nixosModules.apparmor
  ];
  age.secrets.k3s-token.file = "${self}/secrets/k3s-token.age";
  services.k3s =
    let
      k3sFlags = [
        "--flannel-iface=enp7s0"
        "--data-dir=/var/lib/k3s"
        # k3s disables this port by default, we re-enable it to conform to
        # standard k8s behaviour.
        "--kubelet-arg read-only-port=10255"
        "--kubelet-arg image-gc-high-threshold=65"
        "--kubelet-arg image-gc-low-threshold=50"
      ];
    in
    {
      enable = true;
      role = "agent";
      tokenFile = config.age.secrets.k3s-token.path;
      serverAddr = "https://10.0.0.3:6443";
      extraFlags = lib.concatStringsSep " " k3sFlags;
    };
}
