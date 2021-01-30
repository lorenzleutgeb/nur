{ ... }:

{
  programs.autorandr = {
    enable = true;
    hooks.postswitch.polybar = "systemctl --user restart polybar";
  };
}
