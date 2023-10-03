{newScope, ...}: let
  self = {
    kmonad-bin = callPackage ./kmonad-bin {};
    quint = callPackage ./quint.nix {};
    apalache = callPackage ./apalache.nix {};
    tessla = callPackage ./tessla.nix {};
    benchexec = callPackage ./benchexec.nix {};
    cpu-energy-meter = callPackage ./cpu-energy-meter.nix {};
    pqos-wrapper = callPackage ./pqos-wrapper.nix {};
  };
  callPackage = newScope (self // {inherit callPackage;});
in
  self
