{ pkgs, ... }:
{
  # SoundCraft audio editor, pulled from nixpkgs-unstable via the overlay in flake.nix
  home.packages = [ pkgs.soundcraft ];
}
