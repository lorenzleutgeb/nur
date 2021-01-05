{ ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      synctex = true;
      synctex-editor-command = "nvr --remote-silent %f -c %l";
    };
  };
}
