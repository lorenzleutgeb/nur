{...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];
    defaultCommand = "fd --type f";
    defaultOptions = ["--height 40%" "--border"];
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = ["--height 40%" "--border"];
    #historyWidgetCommand = "fd --type f";
    historyWidgetOptions = ["--height 40%" "--border"];
  };

  home.sessionVariables = {
    "FZF_TMUX_HEIGHT" = "80%";
    "FZF_COMPLETION_OPTS" = "--preview='batree {1}'";
  };
}
