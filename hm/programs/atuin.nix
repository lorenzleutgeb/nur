{config, ...}: let
  key = "atuin/key";
in {
  sops.secrets.${key} = {};

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      style = "compact";
      sync_frequency = "30m";
      update_check = "false";
      key_file = config.sops.secrets.${key}.path;
    };
  };
}
