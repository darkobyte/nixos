{ pkgs, ... }:
{
  # Compositor itself and its session target are system-level (system/desktop/mango.nix)

  # Tools used by the keybinds in config/mango/config.conf
  home.packages = with pkgs; [
    wlr-randr
    wl-clipboard
    brightnessctl
  ];

  # MangoWC config, validated at build time with `mango -p`
  xdg.configFile."mango/config.conf".source =
    pkgs.runCommand "mango-config.conf" { } ''
      ${pkgs.mangowc}/bin/mango -c ${../../config/mango/config.conf} -p
      cp ${../../config/mango/config.conf} $out
    '';
}
