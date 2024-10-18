{ inputs, config, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];
  age.rekey = {
    masterIdentities = [
      {
        identity = "~/.ssh/id_abstract.pub"; # Password protected external master key
        pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrS4ctYLXmgmCHVsm+x0nH4KVueUNKN8joK/5CrK5Ft snglth@hewley";
      }
    ];
    storageMode = "local";
    # Choose a directory to store the rekeyed secrets for this host.
    # This cannot be shared with other hosts. Please refer to this path
    # from your flake's root directory and not by a direct path literal like ./secrets
    localStorageDir = ./. + "/secrets/rekeyed/${config.networking.hostName}";
  };
}
