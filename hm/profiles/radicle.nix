{pkgs, ...}: let
  radicle-storage = pkgs.writeShellApplication {
    name = "rad-storage";
    text = ''
      set -euo pipefail
      RID="$(rad .)"
      RID="''${RID:4}"
      git -C "$(rad path)/storage/''${RID}" "''${@:1}"
    '';
  };
in {
  imports = [
    ./rust.nix
  ];

  home.packages = with pkgs; [
    attic-client
    openssl
    openssl.dev
    pkg-config
    radicle-tui
    radicle-storage
  ];
}
