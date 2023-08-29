{
  lib,
  pkgs,
  osConfig,
  ...
}:
with builtins; {
  home.packages = let
    nix-nom = 
      pkgs.writeShellApplication {
        name = "nix-nom";
        text = ''
        set -euo pipefail
        if [ "$1" = "build" ] || [ "$1" = "shell" ] || [ "$1" = "develop" ]
        then
          ${pkgs.nix-output-monitor}/bin/nom "''${@:1}"
        else
          ${osConfig.nix.package}/bin/nix "''${@:1}"
        fi
      ''; };
    in
    (map (x: (pkgs.writeScriptBin x (readFile (./. + "/${x}"))))
    (attrNames (readDir ./.))) ++ [
    nix-nom
    ];
}
