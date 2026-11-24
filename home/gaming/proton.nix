{ pkgs, ... }:
{
  home.packages = with pkgs; [
    protonup-qt
    protontricks
  ];

  # Where ProtonUp-Qt installs custom Proton builds (e.g. GE-Proton)
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
  };
}
