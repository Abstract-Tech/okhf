{
  flake,
  config,
  pkgs,
  ...
}:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    inputs.simple-nixos-mailserver.nixosModule
  ];

  mailserver = {
    enable = true;
    enableImap = true;
    enableImapSsl = true;
    fqdn = "mail.abzt.de";
    domains = ["abzt.de"];

    loginAccounts = {
      "openedx@abzt.de" = {
        hashedPasswordFile = config.age.secrets.openedx-email-password.path;
      };
    };

    certificateScheme = "acme-nginx";
  };
}
