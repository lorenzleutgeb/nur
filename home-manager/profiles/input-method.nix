{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    m17n_db
    m17n_lib
  ];

  i18n.inputMethod = let method = "fcitx5"; in {
    enabled = method;
    ${method}.addons = [ fcitx5-m17n ];
  };
}
