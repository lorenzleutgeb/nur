{
  pkgs,
  osConfig,
  ...
}: let
  explorer = pkgs.writeShellScriptBin "explorer" ''
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
    /mnt/c/Windows/explorer.exe $@
    exit 0
  '';
in {
  home = {
    file."id".text = osConfig.networking.hostName;
    sessionVariables.BROWSER = explorer;
  };

  programs.zsh.shellAliases = {
    "wsl-open" = "${explorer}/bin/explorer";
    "x-www-browser" = "${explorer}/bin/explorer";
  };

  xdg = {
    mimeApps.defaultApplications = {
      "*" = "explorer.desktop";
      "application/pdf" = "explorer.desktop";
      "x-scheme-handler/http" = "explorer.desktop";
      "x-scheme-handler/https" = "explorer.desktop";
      "x-scheme-handler/about" = "explorer.desktop";
      "x-scheme-handler/unknown" = "explorer.desktop";
      "x-scheme-handler/mailto" = "explorer.desktop";
    };
    desktopEntries.explorer = {
      name = "Windows Explorer";
      genericName = "Filesystem Browser";
      exec = "${explorer}/bin/explorer";
      categories = ["Application"];
    };
  };
}
