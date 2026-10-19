{ inputs, ... }:

{
  imports = [
    inputs.exocortex.homeManagerModules.default
  ];

  programs.exocortex.enable = true;
}
