{ pkgs, ... }:
{
  # DeckCraft presentation app, pulled from nixpkgs-unstable via the overlay in flake.nix
  home.packages = [ pkgs.deckcraft ];
}
