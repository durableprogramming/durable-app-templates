{ pkgs, lib, config, inputs, ... }:

{

  packages = with pkgs; [ pkgs.git];

  # https://devenv.sh/languages/
  languages.ruby.enable = true;

  enterShell = ''
  '';

  enterTest = ''
  '';

}
