{ pkgs, lib, ... }:
let
  # Blender side of blender-mcp: a socket server addon that the MCP server below talks to
  blenderMcpAddon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ahujasid/blender-mcp/2e4b0bc294694b1570d76ed01be657c22e6d02a0/addon.py";
    hash = "sha256-p7OHOu2EBb0nhSkqubkWpDkhKfgqAqM2tirBSqEhgos=";
  };
  blenderDir = lib.versions.majorMinor pkgs.blender.version;
in
{
  home.packages = [ pkgs.blender ];

  # Listed as "MCP for Blender"; its socket server auto-starts on localhost:9876 once enabled
  xdg.configFile."blender/${blenderDir}/scripts/addons/blender_mcp.py".source = blenderMcpAddon;

  # Blender only loads add-ons enabled in userpref.blend, so enable it from a startup script.
  # Startup scripts run before the add-on paths are set up (and a failed enable with
  # default_set drops it from the prefs), so defer until the first event-loop tick.
  xdg.configFile."blender/${blenderDir}/scripts/startup/enable_blender_mcp.py".text = ''
    import addon_utils
    import bpy


    def _enable():
        if "blender_mcp" not in bpy.context.preferences.addons:
            addon_utils.enable("blender_mcp", default_set=True, persistent=True)


    def register():
        bpy.app.timers.register(_enable, first_interval=0.1)


    def unregister():
        pass
  '';

  programs.claude-code.mcpServers.blender = {
    type = "stdio";
    command = "${pkgs.uv}/bin/uvx";
    args = [ "--python" "${pkgs.python3}/bin/python3" "blender-mcp==2.0.0" ];
    env = {
      UV_PYTHON_DOWNLOADS = "never";
      DISABLE_TELEMETRY = "true";
    };
  };
}
