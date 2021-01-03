{ ... }:

{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    verbose = true;
  };

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';
}
