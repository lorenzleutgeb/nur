{pkgs, ...}: {
  home = {
    sessionPath = ["$HOME/.cargo/bin"];
    packages = with pkgs; [rustup];
  };

  programs.vscode = {
    userSettings = {
      "rust-analyzer.updates.askBeforeDownload" = false;
    };
    extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
    ];
  };
}
