{ pkgs, ... }:
{
  # FilmCraft video editor, pulled from nixpkgs-unstable via the overlay in flake.nix
  home.packages = [ pkgs.filmcraft ];
}
