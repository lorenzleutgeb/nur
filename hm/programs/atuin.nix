{config, ...}: let
  key = "atuin/key";
in {
  sops.secrets.${key} = {};

  programs.atuin = {
    enable = true;
    daemon.enable = true;
    enableFishIntegration = true;
    settings = {
      filter_mode = "workspace";
      key_file = config.sops.secrets.${key}.path;
      keymap_mode = "vim-insert";
      prefers_reduced_motion = "true";
      show_help = "false";
      style = "auto";
      update_check = "false";
      workspaces = "true";
    };
  };
}
