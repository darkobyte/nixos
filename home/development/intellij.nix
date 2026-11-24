{ pkgs, ... }:
let
  ideaWrapper = pkgs.writeShellScriptBin "intellij" ''
    exec ${pkgs.jetbrains.idea}/bin/idea "$@"
  '';
in
{
  home.packages = [
    pkgs.jetbrains.idea
    ideaWrapper
  ];
}
