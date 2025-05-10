{
  pkgs,
  config,
  osConfig,
  ...
}:
with builtins; {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";

    shellAliases = {
      cat = assert elem pkgs.bat config.home.packages; "bat";
      ls = assert elem pkgs.eza config.home.packages; "eza --time-style=long-iso --git";
      tungz = "tar xvzf";
      #lst = assert elem pkgs.eza config.home.packages; "eza --git --tree --long --time-s
      ducks = "du -cks * | sort -rn | head";

      g = "git";
      d = "docker";

      nix = "nix-nom";

      machine-hash = "nix-hash --type sha256 --base32 --flat /etc/machine-id";
      lngc = "find . -xtype l -delete";

      # Generate SSHFP records (can be imported to Cloudflare).
      sshfp = "ssh-keygen -r $(hostname) > sshfp.txt";

      # Flash new firmware to an ErgoDox EZ keyboard.
      ez-flash = "wally-cli $(eza --online --sort=oldest ~/Downloads/ergodox*.hex | head -1)";

      fix-interpreter = "patchelf --set-interpreter \"$(cat $NIX_CC/nix-support/dynamic-linker)\"";

      poison = ". <(nix print-dev-env)";

      wolgrep = "ngrep -t -W single '\\xff{6}(.{6})\\1{15}' 'port 9'";
    };

    zplug = {
      enable = true;
      plugins = [
        {
          name = "mafredri/zsh-async";
          tags = ["from:github"];
        }
        {
          name = "rupa/z";
          tags = ["use:z.sh"];
        }
        {name = "zsh-users/zsh-completions";}
        {
          name = "ael-code/zsh-colored-man-pages";
          tags = ["from:github"];
        }
        {
          name = "zsh-users/zsh-autosuggestions";
          tags = ["use:zsh-autosuggestions.zsh"];
        }
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = ["as:plugin" "defer:2"];
        }
        {
          name = "zsh-users/zsh-history-substring-search";
          tags = ["as:plugin"];
        }
        {
          name = "jeffreytse/zsh-vi-mode";
          tags = [];
        }
      ];
    };

    initContent = readFile ./rc;
  };

  home = {
    packages = [pkgs.sqlite];
  };

  home.file.".profile".text =
    if osConfig.users.users."${config.home.username}".shell != pkgs.dash
    then throw "`users.users.\"${config.home.username}\".shell` must be set to `pkgs.dash` (`${pkgs.dash}`) for Laurie's tricks to work."
    else ''
      # https://tratt.net/laurie/blog/2024/faster_shell_startup_with_shell_switching.html
      case $- in
      *i* )
         ${config.programs.zsh.package}/bin/zsh --version > /dev/null && exec ${config.programs.zsh.package}/bin/zsh
         echo "Couldn't run 'zsh'" > /dev/stderr
      ;;
      esac
    '';
}
