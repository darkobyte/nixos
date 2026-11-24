{ pkgs, ... }:
{
  # Hardware design: Verilog simulation, synthesis, and netlist visualization (yosys show -> dot)
  home.packages = with pkgs; [
    iverilog
    yosys
    graphviz
  ];
}
