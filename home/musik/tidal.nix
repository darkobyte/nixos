{ pkgs, lib, config, ... }:
let
  # SuperDirt is the SuperCollider sound engine that Tidal sends patterns to.
  # Pinned here instead of installed with Quarks.install so it is reproducible.
  superdirt = pkgs.fetchFromGitHub {
    owner = "musikinformatik";
    repo = "SuperDirt";
    rev = "v1.7.4";
    hash = "sha256-9qU9CHYAXbN1IE3xXDqGipuroifVaSVXj3c/cDfwM80=";
  };
  # Quark that SuperDirt depends on (vowel effect)
  vowel = pkgs.fetchFromGitHub {
    owner = "supercollider-quarks";
    repo = "Vowel";
    rev = "ab59caa870201ecf2604b3efdd2196e21a8b5446";
    hash = "sha256-zfF6cvAGDNYWYsE8dOIo38b+dIymd17Pexg0HiPFbxM=";
  };
  # Default sample library ("bd", "sn", "hh", ...)
  dirtSamples = pkgs.fetchFromGitHub {
    owner = "tidalcycles";
    repo = "Dirt-Samples";
    rev = "c74fc80f8db8038f6a33648ffef5ac00a07ad402";
    hash = "sha256-OzVvy/L6jfEgGx3dMdhe/PkfMAWVV0HQ9wGy500++fw=";
  };

  supercollider = pkgs.supercollider-with-sc3-plugins;
  ghc = pkgs.haskellPackages.ghcWithPackages (p: [ p.tidal ]);
  tidal = pkgs.haskellPackages.tidal;
  # Tidal's default boot script; its data folder name includes a hash, so find it
  bootTidal = pkgs.runCommand "BootTidal.hs" { } ''
    cp "$(find ${tidal.data}/share -name BootTidal.hs | head -1)" $out
  '';

  superdirtStartup = pkgs.writeText "superdirt-startup.scd" ''
    (
    s.reboot {
      s.options.numBuffers = 1024 * 256;
      s.options.memSize = 8192 * 32;
      s.options.numWireBufs = 2048;
      s.options.maxNodes = 1024 * 32;
      s.options.numOutputBusChannels = 2;
      s.options.numInputBusChannels = 2;
      s.waitForBoot {
        ~dirt.stop;
        ~dirt = SuperDirt(2, s);
        ~dirt.loadSoundFiles("${dirtSamples}/*");
        ~dirt.loadSoundFiles(Platform.userHomeDir +/+ "musik/samples/*");
        s.sync;
        ~dirt.start(57120, 0 ! 12);
        "SuperDirt ready. Start Tidal now.".postln;
      };
      s.latency = 0.3;
    };
    );
  '';

  # Boots SuperCollider + SuperDirt through PipeWire's JACK layer. Leave it running.
  superdirtCmd = pkgs.writeShellScriptBin "superdirt" ''
    exec ${pkgs.pipewire.jack}/bin/pw-jack ${supercollider}/bin/sclang ${superdirtStartup} "$@"
  '';

  # Tidal REPL in the terminal, for when you don't want VS Code
  tidalCmd = pkgs.writeShellScriptBin "tidal" ''
    exec ${ghc}/bin/ghci -ghci-script ${bootTidal} "$@"
  '';
in
{
  home.packages = [ supercollider ghc superdirtCmd tidalCmd ];

  # Tell sclang where SuperDirt and Vowel live
  xdg.configFile."SuperCollider/sclang_conf.yaml".text = ''
    includePaths:
      - ${superdirt}
      - ${vowel}
    excludePaths: []
    postInlineWarnings: false
  '';

  # Starter folder: ~/musik with a first pattern and a place for your own samples.
  # Copied once, so the files stay editable and are never overwritten.
  home.activation.musikStarter = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dir="${config.home.homeDirectory}/musik"
    run mkdir -p "$dir/samples"
    if [ ! -e "$dir/start.tidal" ]; then
      run install -m 644 ${./start.tidal} "$dir/start.tidal"
    fi
  '';
}
