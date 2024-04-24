{
  pkgs,
  osConfig,
  lib,
  ...
}: let
  explorerDrv = pkgs.writeShellApplication {
    name = "explorer";
    meta.mainProgram = "explorer";
    text = ''
      # This script assumes that it is run from within
      # Windows Subsystem for Linux and invokes
      # Windows Explorer on its arguments.
      #
      # It will always return 0 as its exit code.
      # This is because Windows Explorer will always
      # return 1, causing scripts like xdg-open that
      # call it to error.
      #
      # See https://github.com/microsoft/WSL/issues/6565
      /mnt/c/Windows/explorer.exe "$@"
      exit 0
    '';
  };
  explorer = lib.getExe explorerDrv;
in {
  home = {
    file."id".text = osConfig.networking.hostName;
    sessionVariables.BROWSER = explorer;
    packages = with pkgs; [
      desktop-file-utils
    ];
  };

  programs.zsh.shellAliases = {
    "wsl-open" = explorer;
    "x-www-browser" = explorer;
  };

  xdg = {
    mimeApps.defaultApplications = {
      "application/pdf" = "explorer.desktop";
      "x-scheme-handler/http" = "explorer.desktop";
      "x-scheme-handler/https" = "explorer.desktop";
      "x-scheme-handler/about" = "explorer.desktop";
      "x-scheme-handler/unknown" = "explorer.desktop";
      "x-scheme-handler/mailto" = "explorer.desktop";
      "x-scheme-handler/rad" = "rad.desktop";
      "*" = "explorer.desktop";
    };
    desktopEntries = {
      explorer = {
        name = "Windows Explorer";
        genericName = "Filesystem Browser";
        exec = explorer;
        categories = ["Application"];
      };
      rad = {
        name = "Radicle";
        genericName = "Code Forge";
        categories = ["Development" "RevisionControl"];
        exec = "\"sh -c 'xdg-open \"https://app.radicle.at/nodes/seed.radicle.at/\\$1\"' -- \"";
        mimeType = ["x-scheme-handler/rad"];
      };
    };
  };
}
