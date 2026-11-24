{ ... }:
{
  # Base OS shared by every host. Only things that cannot live in Home Manager belong
  # under system/ (boot, daemons, hardware, PAM, groups); user apps live in home/.
  imports = [
    ./boot.nix
    ./nix.nix
    ./locale.nix
    ./users.nix
    ./networking.nix
    ./audio.nix
    ./packages.nix
    ./autopull.nix
  ];
}
