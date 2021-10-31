{ pkgs, ... }: {
  services.vscode-server.enable = true;
  programs.vscode = {
    enable = true;
    #extensions = [ pkgs.vscode-extensions.vscodevim ];
  };
}
