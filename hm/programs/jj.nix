{config, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      ui.default-command = ["log"];
      diff.tool = ["difft" "--color=always" "$left" "$right"];
      user = with config.programs.git; {
        name = userName;
        email = userEmail;
      };
    };
  };

  programs.zsh.shellAliases.j = "jj";
}
