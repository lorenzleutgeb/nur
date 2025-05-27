{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: {
  home = {
    sessionVariables.CDPATH = lib.concatStringsSep ":" (
      ["."]
      ++ (
        let
          src = "${config.home.homeDirectory}/src";
        in ["${src}/git.rg1.mpi-inf.mpg.de" "${src}/rad"]
      )
    );

    shellAliases = {
      cat = assert builtins.elem pkgs.bat config.home.packages; "bat";
      ls = assert builtins.elem pkgs.eza config.home.packages; "eza --time-style=long-iso --git";
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

    file.".profile".text =
      if osConfig.users.users."${config.home.username}".shell != pkgs.dash
      then throw "`users.users.\"${config.home.username}\".shell` must be set to `pkgs.dash` (`${pkgs.dash}`) for Laurie's tricks to work."
      else let
        shell = lib.getExe config.programs.fish.package;
      in ''
        # https://tratt.net/laurie/blog/2024/faster_shell_startup_with_shell_switching.html
        case $- in
        *i* )
           ${shell} --version > /dev/null && exec ${shell}
           echo "Couldn't run '${shell}'" > /dev/stderr
        ;;
        esac
      '';
  };
}
