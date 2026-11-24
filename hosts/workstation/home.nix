{ ... }:
{
  # Home Manager layer: every app for this host, grouped by category (home/<category>/).
  # Import a whole category (../../home/browsers) or single apps (../../home/browsers/firefox.nix).
  imports = [
    ../../home/desktop
    ../../home/network
    ../../home/browsers
    ../../home/files
    ../../home/entertainment
    ../../home/cloud
    ../../home/office/obsidian.nix
    ../../home/office/photocraft.nix
    ../../home/office/filmcraft.nix
    ../../home/office/soundcraft.nix
    ../../home/development/toolchain.nix
    ../../home/development/zed.nix
    ../../home/development/intellij.nix
    ../../home/development/antigravity.nix
    ../../home/development/claude-code.nix
    ../../home/creative
    ../../home/languages
    ../../home/gaming
    ../../home/musik
  ];
}
