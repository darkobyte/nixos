{ pkgs, ... }:
{
  # Minecraft PvP client (AppImage-based, unfree)
  home.packages = [ pkgs.lunar-client ];
}
