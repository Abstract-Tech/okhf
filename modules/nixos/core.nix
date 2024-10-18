{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      coreutils
      dnsutils
      iputils
      ldns
      curl
      fd
      jq
      ripgrep
      ncdu
    ];
  };

  programs.tmux = {
    enable = true;
  };

  programs.htop = {
    enable = true;
    package = pkgs.htop-vim;
  };

  services.eternal-terminal = {
    enable = true;
  };
  networking.firewall.allowedTCPPorts = [ 2022 ];

  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };

  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "24.05";
}
