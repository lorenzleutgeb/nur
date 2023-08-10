{ config, lib, pkgs, ... }:

{
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = lib.mkDefault pkgs.nixVersions.nix_2_16;
    settings = {
      auto-optimise-store = true;
      substituters = [ "https://lean4.cachix.org/" "https://mob.cachix.org/" ];
      trusted-users = [ "lorenz" ];
      trusted-public-keys = [
        "lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk="
        "mob.cachix.org-1:tSCZwvAK6F/+O4zjGUL6GH9wAFURQfptWUOks7Zu1Z0="
      ];
    };
    extraOptions = ''
      allow-import-from-derivation = true
      experimental-features = nix-command flakes no-url-literals repl-flake
      builders-use-substitutes = true
      log-lines = 30
      max-silent-time = 600
      timeout = 7200
      #pure-eval = true
      #use-xdg-base-directories = true
    '';
    gc.automatic = true;
  };
}
