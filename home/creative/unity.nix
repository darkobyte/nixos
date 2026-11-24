{ pkgs, ... }:
let
  # UnityShaderCompiler links libtinfo.so.6. nixpkgs ships it as a symlink to libncursesw.so.6,
  # so the FHS env's ld.so.cache only indexes it by that soname; give it its own
  libtinfo = pkgs.runCommand "libtinfo-compat" { nativeBuildInputs = [ pkgs.patchelf ]; } ''
    install -Dm755 ${pkgs.ncurses}/lib/libncursesw.so.6 $out/lib/libtinfo.so.6
    patchelf --set-soname libtinfo.so.6 $out/lib/libtinfo.so.6
  '';
in
{
  # Install a Unity 6 LTS editor from the Hub. Per project, add the MCP for Unity package via
  # Package Manager > Add package from git URL:
  #   https://github.com/CoplayDev/unity-mcp.git?path=/MCPForUnity#v10.3.0
  # then set Window > MCP for Unity > transport to Stdio and start the bridge.
  home.packages = [ (pkgs.unityhub.override { extraLibs = _: [ libtinfo ]; }) ];

  # Keep the server version in sync with the Unity package tag above
  programs.claude-code.mcpServers.unity = {
    type = "stdio";
    command = "${pkgs.uv}/bin/uvx";
    args = [
      "--python" "${pkgs.python3}/bin/python3"
      "--from" "mcpforunityserver==10.3.0"
      "mcp-for-unity" "--transport" "stdio"
    ];
    env.UV_PYTHON_DOWNLOADS = "never";
  };
}
