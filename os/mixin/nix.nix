{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.etc."nix/inputs/nixpkgs".source = pkgs.path;

  nix = {
    package = lib.mkDefault pkgs.nixVersions.nix_2_17;
    nixPath = ["nixpkgs=/etc/nix/inputs/nixpkgs"];
    settings = {
      auto-optimise-store = true;
      substituters = ["https://lean4.cachix.org/" "https://mob.cachix.org/"];
      trusted-users = ["lorenz"];
      trusted-public-keys = [
        "lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk="
        "mob.cachix.org-1:tSCZwvAK6F/+O4zjGUL6GH9wAFURQfptWUOks7Zu1Z0="
      ];
    };
    extraOptions = ''
      allow-import-from-derivation = true
      experimental-features = nix-command flakes repl-flake
      builders-use-substitutes = true
      log-lines = 30
      max-silent-time = 600
      timeout = 7200
      #pure-eval = true
      #use-xdg-base-directories = true

      # NOTE: Disabling URL literals is desired, but breaks
      # evaluation of ngipkgs as of 2023-08-23. Bring it back
      # once ngipkgs evaluates with it.
      # See <https://github.com/ngi-nix/ngipkgs/issues/39>.
      # experimental-features = no-url-literals
    '';
    gc.automatic = true;
  };

  environment.systemPackages = [
    pkgs.nil
  ];
}
