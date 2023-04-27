{ pkgs, ... }:

{
  home.packages = with pkgs; [ docker-credential-helpers ];

  # XDG Issue: https://github.com/moby/moby/issues/20693
  #xdg.configFile."docker/config.json".text = builtins.toJSON {
  home.file.".docker/config.json".text = builtins.toJSON {
    # To log in to a new registry:
    #   1. `rm ~/.docker/config.json`
    #   2. `docker login`
    #   3. Make sure that `jq '.auths' < ~/.docker/config.json` matches what's below.
    #   4. `rm ~/.docker/config.json`
    #   5. nixos-rebuild
    auths = {
      "ghcr.io" = { };
      "https://index.docker.io/v1/" = { };
    };
    credHelpers = {
      "gcr.io" = "gcloud";
      "us.gcr.io" = "gcloud";
      "eu.gcr.io" = "gcloud";
      "asia.gcr.io" = "gcloud";
      "staging-k8s.gcr.io" = "gcloud";
      "marketplace.gcr.io" = "gcloud";
    };
    # See https://docs.docker.com/engine/reference/commandline/login/#credentials-store
    credsStore = "pass";
  };
}
