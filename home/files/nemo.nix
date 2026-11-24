{ pkgs, ... }:
{
  # Nemo (Cinnamon's file manager) with its extensions; ffmpegthumbnailer adds video
  # thumbnails (trash/MTP/network mounts need services.gvfs, see system/desktop/files.nix).
  # file-roller backs nemo-fileroller's "Compress..." / "Extract Here" context menu entries.
  home.packages = with pkgs; [
    nemo-with-extensions
    ffmpegthumbnailer
    file-roller
  ];

  dconf.settings = {
    # Right-click "Open in Terminal" spawns this in the current folder (default: gnome-terminal)
    "org/cinnamon/desktop/applications/terminal".exec = "foot";
    # No desktop icons layer: Mango + Noctalia own the desktop
    "org/nemo/desktop".show-desktop-icons = false;
  };

  # Folders open in Nemo (Zed also claims inode/directory)
  xdg.mimeApps = {
    enable = true;
    defaultApplications."inode/directory" = [ "nemo.desktop" ];
  };
}
