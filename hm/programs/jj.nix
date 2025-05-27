{
  config,
  pkgs,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      ui.default-command = ["log"];
      diff.tool = ["difft" "--color=always" "$left" "$right"];
      user = with config.programs.git; {
        name = userName;
        email = userEmail;
      };

      core = {
        fsmonitor = "watchman";
        watchman.register-snapshot-trigger = true;
      };
      revset-aliases = {
        "private()" = "description(glob:'wip:*') | description(glob:'private:*') | description(glob:'WIP:*') | description(glob:'PRIVATE:*') | conflicts() | (empty() ~ merges())";
      };

      aliases = {
        dlog = ["log" "-r"];
        l = ["log" "-r" "(trunk()..@):: | (trunk()..@)-"];
        tug = [
          "bookmark"
          "move"
          "--from"
          "closest_bookmark(@)"
          "--to"
          "closest_pushable(@)"
        ];
      };

      fix.tools.rustfmt = {
        command = ["rustfmt" "--emit" "stdout"];
        patterns = ["glob:'**/*.rs'"];
      };

      signing = {
        behavior = "own";
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };
    };
  };

  home = {
    packages = with pkgs; [
      jjui
    ];
    shellAliases = {
      j = "jj";
      jui = "jjui";
      jinit = "jj git init --colocate";
    };
  };
}
