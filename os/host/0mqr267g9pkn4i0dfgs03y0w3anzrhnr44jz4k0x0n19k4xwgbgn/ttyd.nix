# tailscale funnel --bg --set-path=tty 7681
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
  inherit (lib.strings) concatStringsSep;

  user = config.users.users.lorenz;

  attach = ["${getExe pkgs.tmux}" "new-session" "-A" "-s" "ttyd"];
in {
  services.ttyd = {
    enable = true;
    user = user.name;
    entrypoint = attach;
    writeable = false;
  };

  environment.shellAliases."ttyd-attach" = concatStringsSep " " attach;

  # NOTE: For secure socket.
  #systemd.services.ttyd.environment.TMUX_TMPDIR = "/run/user/${builtins.toString user.uid}";

  systemd.services.ttyd.wantedBy = lib.mkForce [];
}
