{newScope, ...}: let
  self = {
    kmonad-bin = callPackage ./kmonad-bin {};
    quint = callPackage ./quint.nix {};
    apalache = callPackage ./apalache.nix {};
    tessla = callPackage ./tessla.nix {};
    zindex = callPackage ./zindex.nix {};

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
