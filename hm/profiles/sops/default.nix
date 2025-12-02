{
  config,
  osConfig,
  modules,
  ...
}: {
  imports = [
    modules.sops
  ];

  sops = let
    r = "/run/user/${builtins.toString osConfig.users.users.${config.home.username}.uid}";
  in {
    defaultSymlinkPath = "${r}/secrets";
    defaultSecretsMountPoint = "${r}/secrets.d";
    defaultSopsFile = ./secret.yaml;
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  };
}
