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
      eamodio.gitlens
      haskell.haskell
      jnoortheen.nix-ide
      justusadam.language-haskell
      matklad.rust-analyzer
      # See https://code.visualstudio.com/docs/cpp/config-linux
      # See https://code.visualstudio.com/docs/cpp/config-wsl
      ms-vscode.cpptools
      vscodevim.vim

      # Not packaged in Nixpkgs:
      #bungcip.better-toml
      #dandric.vscode-jq
      #jq-syntax-highlighting.jq-syntax-highlighting
      #ms-vscode.cmake-tools
      #ms-vscode.cpptools-themes
      #ms-vscode.cpptools-extension-pack
      #TabNine.tabnine-vscode
    ];
  };
}
