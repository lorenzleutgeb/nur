{ ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      synctex = true;
      synctex-editor-command = "nvr --remote-silent %f -c %l";
    };
  };

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
  };
}
