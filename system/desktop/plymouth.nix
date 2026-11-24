{ config, lib, pkgs, ... }:
let
  # Minimal boot splash matching the login screen (system/desktop/greetd.nix):
  # pure black, three small white dots pulsing one after another, no logo or text.
  themeName = "minimal-dots";
  theme = pkgs.runCommand "plymouth-theme-${themeName}" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    dir=$out/share/plymouth/themes/${themeName}
    mkdir -p $dir

    # Soft white dot with an anti-aliased edge
    magick -size 48x48 xc:none -fill '#f5f5f5' -draw 'circle 24,24 24,6' -resize 25% $dir/dot.png

    cat > $dir/${themeName}.plymouth <<EOF
    [Plymouth Theme]
    Name=${themeName}
    Description=Black screen with three pulsing dots
    ModuleName=script

    [script]
    ImageDir=$dir
    ScriptFile=$dir/${themeName}.script
    EOF

    cat > $dir/${themeName}.script <<'EOF'
    Window.SetBackgroundTopColor(0, 0, 0);
    Window.SetBackgroundBottomColor(0, 0, 0);

    dot = Image("dot.png");
    spacing = dot.GetWidth() * 2.2;
    cx = Window.GetX() + Window.GetWidth() / 2;
    cy = Window.GetY() + Window.GetHeight() / 2;

    for (i = 0; i < 3; i++) {
      dots[i] = Sprite(dot);
      dots[i].SetX(cx - dot.GetWidth() / 2 + (i - 1) * spacing);
      dots[i].SetY(cy - dot.GetHeight() / 2);
      dots[i].SetOpacity(0.15);
    }

    t = 0;
    fun refresh() {
      t++;
      for (i = 0; i < 3; i++) {
        wave = (Math.Sin(t / 14 - i * 0.9) + 1) / 2;
        dots[i].SetOpacity(0.15 + 0.85 * wave * wave);
      }
    }
    Plymouth.SetRefreshFunction(refresh);
    EOF
  '';
in
{
  options.boot.silentBoot = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Plymouth splash and hidden boot text. Off in the `recovery` boot entry.";
  };

  config = lib.mkMerge [
    (lib.mkIf config.boot.silentBoot {
      boot = {
        plymouth = {
          enable = true;
          theme = themeName;
          themePackages = [ theme ];
        };

        # Silent boot: no kernel/systemd text before the splash or between it and the greeter
        initrd.verbose = false;
        consoleLogLevel = 3;
        kernelParams = [
          "quiet"
          "splash"
          "udev.log_level=3"
          "rd.udev.log_level=3"
          "systemd.show_status=auto"
        ];
      };
    })

    {
      # Starts Plymouth as early as possible in the initrd
      boot.initrd.systemd.enable = true;

      # Ways out if boot hangs behind the splash:
      # - Esc on the splash switches to the boot log at any time (Plymouth built-in)
      # - the boot menu stays up briefly, so an older generation can always be picked
      # - every generation also gets a "recovery" entry: no splash, full boot text
      # - a failed initrd drops to a root shell instead of hanging
      boot.loader.timeout = 2;
      specialisation.recovery.configuration = {
        system.nixos.tags = [ "recovery" ];
        boot.silentBoot = false;
      };
      boot.initrd.systemd.emergencyAccess = true;
    }
  ];
}
