{
  # Password store is at
  #
  #   ~/.local/share/password-store
  #
  # verify with
  #
  #   pass git rev-parse --show-toplevel
  #
  # and maps to
  #
  #   https://github.com/lorenzleutgeb/password-store
  #
  # verify with
  #
  #   pass git remote -v
  #
  programs.password-store = {
    enable = true;
    # TODO: Maybe install OTP and Update extensions.
  };
}
