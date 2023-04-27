{ lib, pkgs, ... }:

with builtins;

{
  home.packages = (map (x: (pkgs.writeScriptBin x (readFile (./. + "/${x}"))))
    (attrNames (readDir ./.)));
}
