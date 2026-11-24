{ pkgs, ... }:
{
  # PhotoCraft photo editor, pulled from nixpkgs-unstable via the overlay in flake.nix
  home.packages = [ pkgs.photocraft ];
}
