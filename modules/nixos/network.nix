{
  systemd.network.networks."50-enp7s0" = {
    matchConfig.Name = "enp7s0";
    networkConfig.DHCP = "yes";
  };

  networking.firewall.trustedInterfaces = [ "enp7s0" ];
}
