{
  virtualisation.oci-containers.backend = "podman";
  networking.firewall.interfaces."podman+".allowedUDPPorts = [53 5353];
}
