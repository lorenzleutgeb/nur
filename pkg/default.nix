{newScope, ...}: let
  self = {
    #quint = callPackage ./quint.nix {}; # Ignored as of 2023-05-03.
    #apalache = callPackage ./apalache.nix {}; # Broken as of 2023-05-03.
    #tessla = callPackage ./tessla.nix {}; # Broken as of 2023-05-03.
    zindex = callPackage ./zindex.nix {};
    gettex = callPackage ./gettex.nix {};
    cgit-pink-radicle = callPackage ./cgit-pink-radicle/default.nix {};

    caddy = callPackage ./caddy.nix {
      externalPlugins = [
        {
          name = "cloudflare";
          repo = "github.com/caddy-dns/cloudflare";
          version = "bfe272c8525b6dd8248fcdddb460fd6accfc4e84";
        }
      ];
      vendorHash = "sha256-lDaGeHZbIODCDY40QR/+jNRKGYL1v16UbwFhwTdWzX0=";
    };
  };
  callPackage = newScope (self // {inherit callPackage;});
in
  self
