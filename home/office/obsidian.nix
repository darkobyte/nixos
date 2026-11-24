{ pkgs, ... }:
{
  # Obsidian with the Wayland ozone platform for crisp rendering on HiDPI displays
  home.packages = [
    (pkgs.obsidian.override { commandLineArgs = "--ozone-platform-hint=auto"; })
  ];
}
