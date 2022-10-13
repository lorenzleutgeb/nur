{ pkgs, ... }:
let
  libs-dynamic = with pkgs; [
    glibc # NOTE: glibc is dropped in the definition of libs-static. Keep it at index 0!
    gmp.dev # NOTE: Keep.
    mpfr.dev # NOTE: Keep.
    gmp
    mpfr
    flint
    libbacktrace
  ];
  libs-static = [ pkgs.glibc.static ] ++ map
    (with pkgs; pkg: (pkg.override { stdenv = makeStaticLibraries stdenv; }))
    (pkgs.lib.drop 3 libs-dynamic);
in {
  home = {
    packages = with pkgs;
      [
        gcc
        gdb
        doxygen
        #meson ninja
        emacs # for etags
      ] ++ libs-dynamic; # ++ libs-static;
    sessionVariables = {
      CPATH = "/home/lorenz/.nix-profile/include";
      LIBRARY_PATH = "/home/lorenz/.nix-profile/lib";
    };
  };
}
