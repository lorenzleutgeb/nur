{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_vi_key_bindings
      set -U fish_greeting ""
    '';
  };
}
