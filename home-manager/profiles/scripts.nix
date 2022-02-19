{ lib, pkgs, ... }:

with builtins;

{
  home.packages =
    (map (x: pkgs.writeScriptBin x (readFile (./scripts + "/${x}")))
      (attrNames (readDir ./scripts)));
}
