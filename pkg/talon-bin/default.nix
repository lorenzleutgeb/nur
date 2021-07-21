{ stdenv, requireFile, makeWrapper, bzip2, dbus, fetchurl, fontconfig, freetype
, glib, libGL, libxkbcommon_7, python3, sqlite, udev, xorg, xz, zlib
, libpulseaudio, qt5, alacritty, lib }:
with lib;
stdenv.mkDerivation rec {
  pname = "talon";
  version = "89-0.0.8.29-1072-g53955e9";
  /* src = fetchurl {
       url = "https://talonvoice.com/dl/latest/talon-linux.tar.xz";
       sha256 = "1yli85h1jzhm23rzaa9a5swa2vgl5wy6rvv9hfgzjyr5va9fm9g7";
     };
  */
  src = ./talon;
  preferLocalBuild = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    qt5.wrapQtAppsHook
    stdenv.cc.cc
    stdenv.cc.libc
    bzip2
    dbus
    fontconfig
    freetype
    glib
    libGL
    libxkbcommon_7
    python3
    sqlite
    udev
    xorg.libX11
    xorg.libXrender
    xz
    zlib
    libpulseaudio
  ];
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = let
    libPath = makeLibraryPath buildInputs;
    binPath = makeBinPath [ alacritty ];
  in ''
    runHook preInstall
    # Copy Talon to the Nix store
    mkdir -p "$out/bin"
    cp --recursive --target-directory=$out *
    # We don't use this script, so remove it to ensure that it's not run by
    # accident.
    rm $out/run.sh
    # Tell talon where to find glibc
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/talon

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/resources/python/bin/python3
    # Replicate 'run.sh' and add library path

    wrapProgram "$out/talon" \
      --unset QT_AUTO_SCREEN_SCALE_FACTOR \
      --unset QT_SCALE_FACTOR \
      --set   LC_NUMERIC C \
      --set   QT_PLUGIN_PATH "$out/lib/plugins" \
      --set   LD_LIBRARY_PATH "$out/lib:$out/resources/python/lib:$out/resources/pypy/lib:${libPath}" \
      --prefix PATH : "${binPath}"

    # The libbz2 derivation in Nix doesn't provide the right .so filename, so
    # we fake it by adding a link in the lib/ directory
    (
      cd "$out/lib"
      ln -s ${bzip2.out}/lib/libbz2.so.1 libbz2.so.1.0
    )

    ls -la $out
    ln -s $out/talon $out/bin/talon

    echo "#! /bin/sh" > $out/bin/talon-repl
    echo "${python3.out}/bin/python3 $out/resources/repl.py" >> $out/bin/talon-repl
    chmod a+x $out/bin/talon-repl
    patchShebangs $out/bin/talon-repl

    runHook postInstall
  '';
}

