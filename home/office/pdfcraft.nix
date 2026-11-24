{ pkgs, ... }:
{
  # PDFCraft PDF workbench, pulled from nixpkgs-unstable via the overlay in flake.nix
  home.packages = [ pkgs.pdfcraft ];
}
