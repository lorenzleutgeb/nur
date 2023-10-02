{pkgs, ...}: {
  fonts = {
    # If adding a font here does not work, try running
    # fc-cache -f -v
    fonts = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      noto-fonts
    ];

    fontconfig = {
      allowBitmaps = false;
      defaultFonts = {
        sansSerif = ["Fira Sans" "DejaVu Sans"];
        monospace = ["Fira Mono" "DejaVu Sans Mono"];
      };
    };
  };
}
