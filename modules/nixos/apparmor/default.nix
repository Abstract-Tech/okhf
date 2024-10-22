{ lib, pkgs, ... }:
{
  security.apparmor.enable = true;

  environment.etc."apparmor.d" = lib.mkForce { source = "${pkgs.apparmor-profiles}/etc/apparmor.d"; };

  # Containerd wants it https://github.com/k3s-io/containerd/blob/57c526b0002c40137811579988b3f85c8b39dd92/pkg/apparmor/apparmor_linux.go#L38
  system.activationScripts.linkApparmorParser = ''
    mkdir -p /sbin
    ln -sf ${pkgs.apparmor-parser}/bin/apparmor_parser /sbin/apparmor_parser
  '';

  security.apparmor.policies = {
    "docker-edx-sandbox-3.8.6" = {
      enable = true;
      profile = builtins.readFile ./docker-edx-sandbox-3.8.6.conf;
    };
    "docker-edx-sandbox-3.11.9" = {
      enable = true;
      profile = builtins.readFile ./docker-edx-sandbox-3.11.9.conf;
    };
  };
}
