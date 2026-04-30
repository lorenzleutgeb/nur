{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      bpftools

      gnumake

      python3

      z3
      z3.lib
    ];
    sessionVariables = {
      Z3_LIBRARY_PATH = "${pkgs.z3.lib}/lib";
    };
  };
}
