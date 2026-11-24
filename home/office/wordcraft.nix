{ pkgs, ... }:
{
  # WordCraft word processor, pulled from nixpkgs-unstable via the overlay in flake.nix
  home.packages = [ pkgs.wordcraft ];
}
