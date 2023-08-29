{newScope, ...}: let
  self = {
    kmonad-bin = callPackage ./kmonad-bin {};
    quint = callPackage ./quint.nix {};
    apalache = callPackage ./apalache.nix {};
  };
  callPackage = newScope (self // {inherit callPackage;});
in
  self
