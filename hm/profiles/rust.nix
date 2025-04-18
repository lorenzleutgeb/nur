{
  pkgs,
  config,
  ...
}: {
  home = {
    sessionPath = ["$HOME/.cargo/bin"];
    packages = with pkgs; [rustup];
  };

  programs.vscode.profiles.${config.home.username} = {
    userSettings = {
      "rust-analyzer.updates.askBeforeDownload" = false;
    };
    extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
    ];
  };
}
