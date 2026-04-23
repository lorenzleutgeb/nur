{...}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];

    defaultCommand = "fd --type f";
    defaultOptions = ["--style minimal"];

    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = ["--preview 'bat --color=always --style=changes {}'"];
  };
}
