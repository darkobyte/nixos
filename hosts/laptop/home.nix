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
    ../../home/office
    ../../home/development/toolchain.nix
    ../../home/development/hdl.nix
    ../../home/development/zed.nix
    ../../home/development/intellij.nix
    ../../home/development/claude-code.nix
    ../../home/development/vscodium.nix
    ../../home/languages
    ../../home/gaming
  ];
}
