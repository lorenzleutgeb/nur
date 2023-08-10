{pkgs, ...}: {
  home.packages = with pkgs; [alejandra espeak-classic mob];
}
