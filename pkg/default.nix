final: prev:

{
  nodePackages = prev.nodePackages; #// (import ./node {
    #pkgs = prev;
    #lib = prev.lib;
  #});
  kmonad-bin = prev.callPackage ./kmonad-bin { };
  # talon-bin = prev.callPackage ./talon-bin { };
}
