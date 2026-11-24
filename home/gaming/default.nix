{ ... }:
{
  # Steam and GameMode are system-level (system/gaming/)
  imports = [
    ./proton.nix
    ./wine.nix
    ./bottles.nix
    ./heroic.nix
    ./mangohud.nix
    ./quadrapassel.nix
    ./minecraft.nix
  ];
}
