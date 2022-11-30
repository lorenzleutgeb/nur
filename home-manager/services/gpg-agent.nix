{ ... }:

{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    verbose = true;
  };

  /* home.sessionVariables = ''
       export GPG_TTY="$(tty)"
       gpg-connect-agent /bye
       export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
     '';
  */
}
