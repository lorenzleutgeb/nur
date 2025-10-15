{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (builtins) toString;

  inherit (lib) mkIf optional;

  #package = pkgs.radicle-node;
  package = pkgs.radicle-node-overlay;

  tor = osConfig.services.tor.client or {enable = false;};
  ygg =
    (osConfig.services.yggdrasil or {enable = false;})
    // {
      # TODO: Depends on Yggdrasil running on the system.
      # sudo -u yggdrasil yggdrasilctl getSelf
      address = "[200:eb97:1e08:d417:b4a2:806f:9502:b7d7]:58776";
      # NOTE: Currently no capacity to maintain.
      enable = false;
    };
in {
  home.packages = with pkgs; [
    python3Packages.zulip # for rad-zulip
  ];

  systemd.user.services.radicle-node.Service = {
    LoadCredential = "xyz.radicle.node.secret:${config.home.homeDirectory}/.radicle/node/key";
    IPAccounting = true;
    IPAddressAllow = "${tor.socksListenAddress.addr}:${toString tor.socksListenAddress.port}";
    IPAddressDeny = "any";
  };

  programs.radicle = {
    cli = {
      inherit package;
    };
    uri = {
      web-rad.enable = false;
      rad.browser.enable = false;
    };
    settings = {
      preferredSeeds = [];
      node = {
        announcers = [
          "z6MkkPvBfjP4bQmco5Dm7UGsX2ruDBieEHi8n9DVJWX5sTEz"
        ];
        connect = let
          connectAddr = {
            nid,
            addr,
            port,
          }: "${nid}@${addr}:${toString port}";
        in
          (
            let
              nid = "z6MksmpU5b1dS7oaqF2bHXhQi1DWy2hB7Mh9CuN7y1DN6QSz";
            in
              (optional (!ygg.enable && !tor.enable) (connectAddr {
                inherit nid;
                addr = "seed.radicle.xyz";
                port = 58776;
              }))
              ++ (optional tor.enable (connectAddr {
                inherit nid;
                addr = "seedradanrg2oje34eyidx4z63gpuakgaedaetvt7xxw5whv6qnexmid.onion";
                port = 58776;
              }))
          )
          ++ (
            let
              nid = "z6MkocYY4dgMjo2YeUEwQ4BP4AotL7MyovzJCPiEuzkjg127";
            in
              (optional tor.enable (connectAddr {
                inherit nid;
                addr = "q37hn7rhcbqiirapcx5bkgxzue5oqijdmjv55anfht2ne5hxxjxyhhyd.onion";
                port = 8776;
              }))
              ++ (optional ygg.enable (connectAddr {
                inherit nid;
                addr = "[202:f094:502b:1b03:9e0:2c3d:bc8b:428b]";
                port = 8776;
              }))
              ++ (optional (!ygg.enable && !tor.enable) (connectAddr {
                inherit nid;
                addr = "node.radicle.lorenz.leutgeb.xyz";
                port = 8776;
              }))
          )
          ++ (optional tor.enable (connectAddr {
            nid = "z6MkireRatUThvd3qzfKht1S44wpm4FEWSSa4PRMTSQZ3voM";
            addr = "67apylyibh2oeonhwjlkloezjpc2yupjzajfb4o63bwhe75uq2c2dvid.onion";
            port = 8776;
          }));
        onion = mkIf tor.enable {
          mode = "proxy";
          address = "${tor.socksListenAddress.addr}:${toString tor.socksListenAddress.port}";
        };
      };
    };
  };

  services.radicle.node = {
    inherit package;
    enable = true;
    lazy.enable = true;
    environment = {
      GIT_TRACE = "true";
      RUST_BACKTRACE = "full";
    };
    args = "--log debug";
  };

  services.radicle-mirror = {
    "z3gqcJUoA1n9HaHKufZs5FCSGazv5" = {
      remote = "gh:radicle-dev/heartwood";
      refs.watch = ["refs/heads/master"];
      nodes = {
        "z6MkkPvBfjP4bQmco5Dm7UGsX2ruDBieEHi8n9DVJWX5sTEz".alias = "lorenzleutgeb";
        "z6MkireRatUThvd3qzfKht1S44wpm4FEWSSa4PRMTSQZ3voM".alias = "FintanH";
        "z6MksFqXN3Yhqk8pTJdUGLwATkRfQvwZXPqR2qMEhbS9wzpT".alias = "cloudhead";
        "z6MkgFq6z5fkF2hioLLSNu1zP2qEL1aHXHZzGH1FLFGAnBGz".alias = "erak";
      };
    };
    "z39mP9rQAaGmERfUMPULfPUi473tY" = {
      remote = "gh:radicle-dev/radicle-tui";
      refs.watch = ["refs/heads/master"];
      nodes = {
        "z6MkgFq6z5fkF2hioLLSNu1zP2qEL1aHXHZzGH1FLFGAnBGz".alias = "erak";
      };
    };

    "z371PVmDHdjJucejRoRYJcDEvD5pp" = {
      remote = "gh:radicle-dev/radicle.xyz";
      refs.watch = ["refs/heads/master"];
      nodes = {
        "z6MkkPvBfjP4bQmco5Dm7UGsX2ruDBieEHi8n9DVJWX5sTEz".alias = "lorenzleutgeb";
        "z6MkireRatUThvd3qzfKht1S44wpm4FEWSSa4PRMTSQZ3voM".alias = "FintanH";
        "z6MkgFq6z5fkF2hioLLSNu1zP2qEL1aHXHZzGH1FLFGAnBGz".alias = "erak";
      };
    };

    "z6cFWeWpnZNHh9rUW8phgA3b5yGt" = {
      remote = "gh:radicle-dev/radicle.xyz";
      refs.watch = ["refs/heads/master"];
      nodes = {
        "z6MkireRatUThvd3qzfKht1S44wpm4FEWSSa4PRMTSQZ3voM".alias = "FintanH";
      };
    };

    "z3WFXKNQgDcHHATJx1PxL1XhDot9u".remote = "gh:ll/nur";
  };
}
