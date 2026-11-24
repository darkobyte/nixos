{ pkgs, ... }:
{
  # Google Antigravity CLI (command: agy), provided by the antigravity-nix overlay
  home.packages = [ pkgs.google-antigravity-cli ];
}
