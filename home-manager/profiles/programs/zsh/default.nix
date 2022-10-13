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

      g = "git";
      d = "docker";

      machine-hash = "nix-hash --type sha256 --base32 --flat /etc/machine-id";
      lngc = "find . -xtype l -delete";

      # Generate SSHFP records (can be imported to Cloudflare).
      sshfp = "ssh-keygen -r $(hostname) > sshfp.txt";

      # Flash new firmware to an ErgoDox EZ keyboard.
      ez-flash =
        "wally-cli $(exa --online --sort=oldest ~/Downloads/ergodox*.hex | head -1)";

      fix-interpreter = "patchelf --set-interpreter \"$(cat $NIX_CC/nix-support/dynamic-linker)\"";

      poison = ". <(nix print-dev-env)";
    };

    zplug = {
      enable = true;
      plugins = [
        {
          name = "mafredri/zsh-async";
          tags = [ "from:github" ];
        }
        {
          name = "rupa/z";
          tags = [ "use:z.sh" ];
        }
        { name = "zsh-users/zsh-completions"; }
        {
          name = "ael-code/zsh-colored-man-pages";
          tags = [ "from:github" ];
        }
        {
          name = "zsh-users/zsh-autosuggestions";
          tags = [ "use:zsh-autosuggestions.zsh" ];
        }
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = [ "as:plugin" "defer:2" ];
        }
        {
          name = "zsh-users/zsh-history-substring-search";
          tags = [ "as:plugin" ];
        }
        {
          name = "jeffreytse/zsh-vi-mode";
          tags = [ ];
        }
      ];
    };

    initExtra = readFile ./rc;
  };

  home = {
    packages = [ pkgs.sqlite ];
    sessionPath = [ "$HOME/.nix-profile/bin" ];
  };
}
