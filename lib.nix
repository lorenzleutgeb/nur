{lib}: let
  inherit
    (lib)
    listToAttrs
    attrNames
    replaceStrings
    ;
  inherit
    (builtins)
    readDir
    ;
in rec {
  kebabCaseToCamelCase =
    replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

  dirToAttrs = dir:
    listToAttrs (map (name: {
      name = kebabCaseToCamelCase (lib.removeSuffix ".nix" name);
      value = dir + "/${name}";
    }) (attrNames (readDir dir)));
}
