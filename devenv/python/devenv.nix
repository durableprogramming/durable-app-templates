{ pkgs, lib, config, inputs, ... }:

{
  packages = [ pkgs.git ];

  languages.python.enable = true;
  languages.python.venv.enable = true;

  enterShell = ''
  '';

  enterTest = ''
  '';

}
