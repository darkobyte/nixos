{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          # Shift+Enter sends the current block to Tidal
          publisher = "tidalcycles";
          name = "vscode-tidalcycles";
          version = "2.0.2";
          hash = "sha256-TfRLJZcMpoBJuXitbRmacbglJABZrMGtSNXAbjSfLaQ=";
        }
      ];
    };
  };
}
