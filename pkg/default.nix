{newScope, ...}: let
  self = {
    #quint = callPackage ./quint.nix {}; # Ignored as of 2023-05-03.
    #apalache = callPackage ./apalache.nix {}; # Broken as of 2023-05-03.
    #tessla = callPackage ./tessla.nix {}; # Broken as of 2023-05-03.
    concourse = callPackage ./concourse.nix {};
    zindex = callPackage ./zindex.nix {};
    cgit-pink-radicle = callPackage ./cgit-pink-radicle/default.nix {};
  };
  callPackage = newScope (self // {inherit callPackage;});
in
  self
