{ ... }:
{
  # Fuzzel application launcher: minimal monochrome, same palette as the login
  # screen (system/desktop/greetd.nix): black, no border, white/grey text, app icons
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=13";
        dpi-aware = "auto";

        prompt = ''"  "'';
        placeholder = "search";
        icons-enabled = true;
        icon-theme = "breeze-dark";
        show-actions = false;
        terminal = "foot -e";

        anchor = "center";
        lines = 7;
        width = 34;
        line-height = 30;
        horizontal-pad = 32;
        vertical-pad = 24;
        inner-pad = 16;
        layer = "overlay";
      };
      border = {
        width = 0;
        radius = 16;
        selection-radius = 10;
      };
      colors = {
        background = "000000ff";
        text = "8a8a8aff";
        prompt = "8a8a8aff";
        placeholder = "404040ff";
        input = "f5f5f5ff";
        match = "f5f5f5ff";
        selection = "171717ff";
        selection-text = "f5f5f5ff";
        selection-match = "ffffffff";
        message = "8a8a8aff";
        border = "00000000";
      };
    };
  };
}
