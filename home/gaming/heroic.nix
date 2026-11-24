{ pkgs, ... }:
{
  # Epic Games (and GOG/Amazon) launcher. Runs games through its own Wine/Proton builds
  # (Settings > Wine Manager) and picks up GameMode/MangoHud from the per-game settings.
  home.packages = [ pkgs.heroic ];
}
