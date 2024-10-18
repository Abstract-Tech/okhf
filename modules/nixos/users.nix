{ pkgs, ... }:
{
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrS4ctYLXmgmCHVsm+x0nH4KVueUNKN8joK/5CrK5Ft"
      ];
    };
    illia = {
      createHome = true;
      home = "/home/illia";
      description = "Illia Shestakov";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrS4ctYLXmgmCHVsm+x0nH4KVueUNKN8joK/5CrK5Ft"
      ];
      isNormalUser = true;
      shell = pkgs.bash;
    };
    marco = {
      createHome = true;
      home = "/home/marco";
      description = "Marco Chiruzzi";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDav16s5/3VniqxCy0VE4w6l64zQ96+4/CKEuIsP88svNO+0uuHp2m4Q5Xy0JTZYmImHfThtXEHjFpbHmBV5HCcDMQAEZW+AIveeKGkzkjZZNV+bsf96NSyxG8aZG3iRjxfoDryFNuKjKnRtJ9zzJsaGVr3Dq+4xsvvxl1mOWp9RO6YL2/yEaAz8GWQ+ypdF5/38S+rTHNibdhRMuCVFEiwOTAnRCTwV+nqRHEc5UcO2EhkUzzK+2OZMEucjH6k3mmLbpmhSmfK2A24+ahvLjD2Iw64DD8bsxbvZumUFzHoYkQJ41XdPhs2s/QoxntVdLgLisj6Ss/iVz7UKrxUYS+v marco@Gazelle"
      ];
      isNormalUser = true;
      shell = pkgs.bash;
    };
    ghassan = {
      createHome = true;
      home = "/home/ghassan";
      description = "Ghassan Maslamani";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhINWE6nlDFPh8mC/vbwhIE6JNvELbw9MdLL41JkuOz"
      ];
      isNormalUser = true;
      shell = pkgs.bash;
    };
  };
}
