{ pkgs, ... }: {
  services.vscode-server.enable = true;
  programs.vscode = {
    enable = true;
    userSettings = {
      "editor.fontFamily" = "Fira Code, Consolas, monospace";
      "editor.fontLigatures" = true;
      "editor.guides.bracketPairs" = true;

      "lean4.input.languages" = "lean4";

      "update.channel" = "none";

      # TODO: Get rid of hardcoded Tailscale IPs
      "remote.SSH.remotePlatform"."100.85.40.10" = "linux";

      "rust-analyzer.updates.askBeforeDownload" = false;
    };
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      bbenoist.nix
      haskell.haskell
      jnoortheen.nix-ide
      justusadam.language-haskell
      matklad.rust-analyzer
      #rust-lang.rust
      vscodevim.vim

      # Not packaged in Nixpkgs:
      #bungcip.better-toml
      #dandric.vscode-jq
      #jq-syntax-highlighting.jq-syntax-highlighting
      #TabNine.tabnine-vscode
    ];
  };
}
