{...}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    changeDirWidget = {
      command = "fd --type d";
      options = ["--preview 'tree -C {} | head -200'"];
    };

    defaultCommand = "fd --type f";
    defaultOptions = ["--style minimal"];

    fileWidget = {
      command = "fd --type f";
      options = ["--preview 'bat --color=always --style=changes {}'"];
    };

    historyWidget.fish.command = "";
  };
}
