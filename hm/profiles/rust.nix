{
  pkgs,
  config,
  lib,
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

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "${lib.getExe pkgs.clang}"
    rustflags = ["-C", "link-arg=-fuse-ld=${lib.getExe pkgs.mold}"]
  '';
}
