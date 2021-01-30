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
      d = "docker";

      machine-hash = "nix-hash --type sha256 --base32 --flat /etc/machine-id";
      lngc = "find . -xtype l -delete";

      # Generate SSHFP records (can be imported to Cloudflare).
      sshfp = "ssh-keygen -r $(hostname) > sshfp.txt";

      # Flash new firmware to an ErgoDox EZ keyboard.
      ez-flash = "wally $(ls -t -1 ~/Downloads/ergodox*.hex | head -1)";
    };

    initExtra = readFile ./rc;
  };
}
