{
  config,
  lib,
  pkgs,
  ...
}: {
  xdg.configFile = let
    files = builtins.attrNames (builtins.readDir ./.);
    tomls = builtins.filter (lib.hasSuffix ".toml") files;
    tomlToXdg = name: {
      name = "jj/conf.d/${name}";
      value.source = ./. + "/${name}";
    };
  in (
    builtins.listToAttrs (map tomlToXdg tomls)
  );

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        inherit (config.programs.git.settings.user) name email;
      };
    };
  };

  home = {
    packages = with pkgs; [
      jjui
    ];
    shellAliases = {
      j = "jj";
      jui = "jjui";
    };
  };
}
