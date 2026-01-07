{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /etc/nixos 2775 root wheel -"
    "A+ /etc/nixos - - - - d:u::rwx,d:g::rwx,d:o::rx"
  ];
}
