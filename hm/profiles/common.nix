{
  pkgs,
  config,
  ...
}: {
  imports = [./yubikey.nix ../scripts];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
    userDirs.enable = true;
  };

  manual.html.enable = true;

  fonts.fontconfig.enable = pkgs.lib.mkForce true;

  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "20.03";

    sessionPath = ["$HOME/bin"];
    packages = [pkgs.xdg-utils];

    sessionVariables = {
      XDG_RUNTIME_DIR = "/var/run/user/$UID";
    };
  };
}
