{ config, pkgs, ... }:
let
  # Wraps the MCP-aware build so hosts' programs.claude-code.mcpServers apply to every entry point
  claude = config.programs.claude-code.finalPackage;

  # Convenience wrapper allowing invocation via `claude-code` as well as upstream `claude`
  claudeCodeWrapper = pkgs.writeShellScriptBin "claude-code" ''
    exec ${claude}/bin/claude "$@"
  '';
in
{
  programs.claude-code.enable = true;

  home.packages = [ claudeCodeWrapper ];

  # Launcher entry for fuzzel / app menus
  xdg.desktopEntries.claude-code = {
    name = "Claude Code";
    genericName = "AI Coding Assistant";
    comment = "Anthropic's terminal-based agentic coding tool";
    exec = "foot -e ${claude}/bin/claude";
    icon = "utilities-terminal";
    terminal = false;
    categories = [ "Development" ];
  };
}
