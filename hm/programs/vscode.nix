{pkgs, ...}: {
  services.vscode-server.enable = true;
  programs = {
    java.enable = true; # Some extensions, e.g. `valentjn.vscode-ltex` require Java.

    vscode = {
      enable = true;
      userSettings = {
        "editor.fontFamily" = "Fira Code, Consolas, monospace";
        "editor.fontLigatures" = true;
        "editor.guides.bracketPairs" = true;
        "lean4.input.languages" = "lean4";
        "remote.SSH.remotePlatform"."0mqr.lorenz.hs.leutgeb.xyz" = "linux";
        "rust-analyzer.updates.askBeforeDownload" = false;
        "update.channel" = "none";
      };
      extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        bbenoist.nix
        eamodio.gitlens
        github.copilot
        haskell.haskell
        jnoortheen.nix-ide
        justusadam.language-haskell
        matklad.rust-analyzer
        mkhl.direnv
        ms-python.python
        # See https://code.visualstudio.com/docs/cpp/config-linux
        # See https://code.visualstudio.com/docs/cpp/config-wsl
        ms-vscode.cpptools
        #leanprover.lean4
        vscodevim.vim

        # Not packaged in Nixpkgs:
        #bungcip.better-toml
        #dandric.vscode-jq
        #jq-syntax-highlighting.jq-syntax-highlighting
        #ms-python.flake8
        #ms-vscode.cmake-tools
        #ms-vscode.cpptools-themes
        #ms-vscode.cpptools-extension-pack
        #TabNine.tabnine-vscode
      ];
    };
  };
}
