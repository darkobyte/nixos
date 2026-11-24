{ config, pkgs, ... }:
{
  # GTK Theme (Forces dark mode for GTK applications and desktop portals)
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze-icons;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.theme = config.gtk.theme;
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # FreeDesktop / GNOME Portal color-scheme preference
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "breeze-dark";
    };
  };

  home.packages = [ pkgs.adwaita-icon-theme ];

  home.sessionVariables.GTK_THEME = "Adwaita:dark";

  # KDE / Qt apps globals: the full Breeze Dark color scheme plus icons and widget style
  # (a partial scheme leaves the missing color roles light)
  xdg.configFile."kdeglobals".source = pkgs.concatText "kdeglobals" [
    "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors"
    ../../config/kde/kdeglobals
  ];

  # Disable KWallet for user sessions
  xdg.configFile."kwalletrc".source = ../../config/kde/kwalletrc;
}
