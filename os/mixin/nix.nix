{
  config,
  pkgs,
  ...
}: {
  programs.nix-ld.enable = true;

  environment = {
    etc."nix/inputs/nixpkgs".source = pkgs.path;
    systemPackages = [
      pkgs.nil
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    nixPath = ["nixpkgs=/etc/${config.environment.etc."nix/inputs/nixpkgs".target}"];
    settings = {
      auto-optimise-store = true;
      substituters = ["https://lean4.cachix.org/"];
      trusted-users = ["lorenz"];
      trusted-public-keys = [
        "lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk="
      ];
    };
    extraOptions = ''
      allow-import-from-derivation = true
      experimental-features = nix-command flakes
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
}
