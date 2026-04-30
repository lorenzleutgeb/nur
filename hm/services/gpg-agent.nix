{
  pkgs,
  osConfig,
  ...
}: {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-tty;
    verbose = true;
  };

  /*
  home.sessionVariables = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/${builtins.toString osConfig.users.users.${config.home.username}.uid}/gnupg/S.gpg-agent.ssh"
  '';
  */
}
