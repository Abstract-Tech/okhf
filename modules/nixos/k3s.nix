{
  boot.kernelModules = [ "ip_conntrack" "ip_vs" "ip_vs_rr" "ip_vs_wrr" "ip_vs_sh" ];
  networking.firewall.trustedInterfaces = [ "cni+" ];
}