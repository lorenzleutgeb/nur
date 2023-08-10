{pkgs, ...}: {
  home.packages = with pkgs; [isabelle];

  # Each line contains one directory entry in Isabelle path notation.
  # TODO: Avoid hardcoding this.
  home.file.".isabelle/Isabelle2021/ROOTS".text = ''
    /home/lorenz/src/foss.heptapod.net/isa-afp/afp-2021/thys
  '';
}
