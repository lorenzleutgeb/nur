{ ... }:

with builtins;

{
  xdg.configFile."autorandr/default/config".text = readFile ./default/config;
  xdg.configFile."autorandr/default/setup".text = readFile ./default/setup;

  xdg.configFile."autorandr/gr/config".text = readFile ./gr/config;
  xdg.configFile."autorandr/gr/setup".text = readFile ./gr/setup;
}
