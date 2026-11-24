{ pkgs, ... }:
{
  # GridCraft spreadsheet, pulled from nixpkgs-unstable via the overlay in flake.nix
  home.packages = [ pkgs.gridcraft ];
}
