let
  illia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrS4ctYLXmgmCHVsm+x0nH4KVueUNKN8joK/5CrK5Ft";
  marco = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/S367u0mWxnes1aQytTpN5VTZD0pW5MnDuZDJgSUhg";
  users = [
    illia
    marco
  ];

  mysqlKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOsC8BqVr2eG8P1rzDKVfyc/lVMZ67O2vxs5rd8ZA8AU";
  redisKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNvZkrDzYJ8WMJpNqgl4BwgdehUHf5hWOEJecgQ3pSz";
  k3sServerKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwSV6yTdWWjhFiX9l6QVoRw5ieMxoUdb22fICz2Y7zO";
  k3sAgentKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8f1SUcpYvdOsmEcQ1VGFqI2E1j1vvdif63t8jc/4GG"
  ];
  k3sKeys = [ k3sServerKey ] ++ k3sAgentKeys;
in
{
  "mysql.age".publicKeys = users ++ [ mysqlKey ];
  "redis.age".publicKeys = users ++ [ redisKey ];
  "k3s-token.age".publicKeys = users ++ k3sKeys;
}
