{ pkgs, lib, ... }:
let
  # Bake flags into the package itself so every launch path (app launcher, xdg-open,
  # terminal) gets them. Without --password-store=basic Brave probes KWallet over D-Bus
  # and stalls ~25s on startup.
  brave = pkgs.brave.override {
    commandLineArgs = "--password-store=basic --ozone-platform-hint=auto";
  };

  braveClean = lib.hiPrio (pkgs.writeShellScriptBin "brave" ''
    # Automatically clean stale Singleton lock left over from previous hostname/shutdown
    if [ -d "$HOME/.config/BraveSoftware/Brave-Browser" ]; then
      rm -f "$HOME/.config/BraveSoftware/Brave-Browser/Singleton"*
    fi
    exec ${brave}/bin/brave "$@"
  '');

  braveBrowserClean = lib.hiPrio (pkgs.writeShellScriptBin "brave-browser" ''
    exec ${braveClean}/bin/brave "$@"
  '');
in
{
  home.packages = [
    brave
    braveClean
    braveBrowserClean
  ];
}
