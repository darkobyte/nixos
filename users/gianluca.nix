# One file per account. Add a file → the account exists after `rebuild`;
# delete it (or drop a host below) → the account is removed there (/home stays on disk).
#
# Every user always gets the base (home/default.nix): Mango + Noctalia desktop, login look,
# CLI, Firefox, Nemo and the standard folders. List only what is personal here.
# Paths are relative to home/: a whole category ("gaming") or one app ("office/obsidian.nix").
{
  fullName = "gianluca sima";
  email = "darkobyte@users.noreply.github.com";   # git identity

  # sudo + allowed to run `rebuild`
  admin = true;

  # On every host below
  apps = [
    "network"
    "browsers"
    "entertainment"
    "cloud"
    "office/obsidian.nix"
    "office/photocraft.nix"
    "office/filmcraft.nix"
    "office/soundcraft.nix"
    "development/toolchain.nix"
    "development/zed.nix"
    "development/intellij.nix"
    "development/claude-code.nix"
    "languages"
    "gaming"
  ];

  # Hosts this account exists on, each with extra apps for that host only
  hosts = {
    laptop = [
      "office/wordcraft.nix"
      "office/gridcraft.nix"
      "office/deckcraft.nix"
      "office/pdfcraft.nix"
      "development/hdl.nix"
      "development/vscodium.nix"
    ];
    workstation = [
      "development/antigravity.nix"
      "creative"
      "musik"
    ];
  };
}
