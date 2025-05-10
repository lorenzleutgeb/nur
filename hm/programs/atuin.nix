{config, ...}: let
  key = "atuin/key";
in {
  sops.secrets.${key} = {};

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      style = "compact";
      sync_frequency = "30m";
      update_check = "false";
      key_file = config.sops.secrets.${key}.path;
    };
  };

  programs.zsh.initContent = ''
    bindkey -M viins '^R' _atuin_search_widget
    bindkey -M vicmd '^R' _atuin_search_widget
  '';
}
