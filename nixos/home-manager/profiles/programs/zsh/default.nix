{ pkgs, config, ... }:

with builtins;

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";

    shellAliases = {
      cat = assert elem pkgs.bat config.home.packages; "bat";
      ls = assert elem pkgs.exa config.home.packages;
        "exa --time-style=long-iso --git";
      tungz = "tar xvzf";
      #lst = assert elem pkgs.exa config.home.packages; "exa --git --tree --long --time-s
      ducks = "du -cks * | sort -rn | head";
      git = "hub";
      g = "hub";
      home = "git --git-dir=$HOME/.config/home --work-tree=$HOME";
      d = "docker";
      machine-hash = "nix-hash --type sha256 --base32 --flat /etc/machine-id";
      lngc = "find . -xtype l -delete";
    };

    initExtra = readFile ./rc;
  };
}
