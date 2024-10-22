{
  flake,
  config,
  pkgs,
  ...
}:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  pwd = config.age.secrets."mysql.age".path;
in
{
  imports = [
    self.nixosModules.default
  ];

  age.secrets."mysql.age" = {
    file = "${self}/secrets/mysql.age";
    owner = "mysql";
  };

  services.mysql = {
    enable = true;
    package = pkgs.percona-server_8_0;
  };

  systemd.services.mysql.postStart = ''
    (
    echo "CREATE DATABASE IF NOT EXISTS openedx;";
    echo "CREATE USER IF NOT EXISTS 'openedx'@'%' IDENTIFIED BY '$(cat ${pwd})';"
    echo "GRANT ALL PRIVILEGES ON openedx.* TO 'openedx'@'%';"
    echo "FLUSH PRIVILEGES;"
    ) | ${config.services.mysql.package}/bin/mysql -N
  '';
}
