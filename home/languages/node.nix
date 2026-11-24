{ pkgs, ... }:

let
  # Pin the Node.js version you want to use everywhere in this module
  nodePkg = pkgs.nodejs_22; # or pkgs.nodejs_20, pkgs.nodejs (current LTS)
in
{
  home.packages = with pkgs; [
    nodePkg         # also ships npm and corepack

    # Node Package Managers & Runtimes
    pnpm
    yarn
    bun             # Modern, fast alternative runtime & package manager

    # Build tools required for compiling native npm addons (node-gyp)
    gnumake
    gcc
    python3
  ];

  home.sessionVariables = {
    # Where global packages install binaries (e.g. npm install -g <pkg>)
    # Avoids needing sudo for global installs
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";

    # Ensure native build tools find Python
    PYTHON = "${pkgs.python3}/bin/python3";
  };

  # User-level global binaries
  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.bun/bin"
  ];
}
