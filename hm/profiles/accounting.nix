{
  lib,
  pkgs,
  ...
}:
with builtins; {
  home.packages = with pkgs; [
    hledger
    hledger-web
  ];
}
