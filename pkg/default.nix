final: prev:

{
  nodePackages = prev.nodePackages // (import ./node { pkgs = prev; });
  kmonad-bin = prev.callPackage ./kmonad-bin { };
  talon-bin = prev.callPackage ./talon-bin { };
}
