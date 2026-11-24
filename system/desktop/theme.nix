{ ... }:
{
  # Stable wallpaper path, referenced by config/noctalia/config.toml ([wallpaper.default])
  environment.etc."pulsar/wallpaper.jpg".source = ../../assets/wallpapers/default.jpg;

  # Required by Home Manager's gtk/dconf settings (home/desktop/theme.nix)
  programs.dconf.enable = true;
  # Qt apps read kdeglobals only through KDE's platform theme, which
  # Qt doesn't pick outside Plasma unless told to
  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };
}
