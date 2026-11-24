{ pkgs, ... }:
{
  # Parsec client for remote desktop / game streaming to other PCs
  home.packages = [ pkgs.parsec-bin ];
}
