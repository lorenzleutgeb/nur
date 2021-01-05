{ ... }:

{
  # XDG Issue: https://github.com/moby/moby/issues/20693
  home.file.".docker/config.json".text = builtins.toJSON {
    auths = { };
    credHelpers = {
      "gcr.io" = "gcloud";
      "us.gcr.io" = "gcloud";
      "eu.gcr.io" = "gcloud";
      "asia.gcr.io" = "gcloud";
      "staging-k8s.gcr.io" = "gcloud";
      "marketplace.gcr.io" = "gcloud";
    };
  };
}
