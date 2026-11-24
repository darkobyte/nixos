{ ... }:
{
  # Foot terminal (clean dark mode)
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        pad = "16x16";
      };
      colors-dark = {
        alpha = 0.94;
        background = "0b0f19";
        foreground = "e2e8f0";
      };
    };
  };
}
