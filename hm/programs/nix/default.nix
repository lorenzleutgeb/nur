{...}: {
  xdg.configFile."nix/config.nix".source = ./config.nix;

  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    nix-index-database.comma.enable = true;
  };
}
