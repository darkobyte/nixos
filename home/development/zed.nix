{ pkgs, ... }:
let
  # `zed` command alongside upstream's `zeditor`
  zedScript = pkgs.writeShellScriptBin "zed" ''
    exec ${pkgs.zed-editor}/bin/zeditor "$@"
  '';
in
{
  home.packages = [
    pkgs.zed-editor
    zedScript
  ];

  # Launcher entry so Zed is easy to find in fuzzel/menus
  xdg.desktopEntries.zed = {
    name = "Zed";
    genericName = "Text Editor";
    comment = "A high-performance, multiplayer code editor.";
    exec = "${pkgs.zed-editor}/bin/zeditor %F";
    icon = "zed";
    terminal = false;
    categories = [ "Development" "TextEditor" "IDE" ];
    mimeType = [ "text/plain" "inode/directory" ];
  };
}
