{
  lib,
  pkgs,
  osConfig ? null,
  config,
  ...
} @ args: let
  nix = (args.osConfig or config).nix.package;
in
  with builtins; {
    home.packages = let
      nix-nom = pkgs.writeShellApplication {
        name = "nix-nom";
        text = ''
          set -euo pipefail
          if [ "$1" = "build" ] || [ "$1" = "shell" ] || [ "$1" = "develop" ]
          then
            ${lib.getExe pkgs.nix-output-monitor} "''${@:1}"
          else
            ${lib.getExe nix} "''${@:1}"
          fi
        '';
      };
    in
      (map (x: (pkgs.writeScriptBin x (readFile (./. + "/${x}"))))
        (attrNames (readDir ./.)))
      ++ [
        nix-nom
      ];
  }
