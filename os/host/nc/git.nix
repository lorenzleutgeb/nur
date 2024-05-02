{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) concatStringsSep mapAttrsToList optionalString concatStrings;
  port = "5001";

  cgitrcLine = name: value: "${name}=${
    if value == true
    then "1"
    else if value == false
    then "0"
    else toString value
  }";

  mkCgitrc = let
    cfg = config.services.cgit.radicle;
  in
    pkgs.writeText "cgitrc" ''
      # global settings
      ${
        concatStringsSep "\n" (
          mapAttrsToList
          cgitrcLine
          ({virtual-root = cfg.nginx.location;} // cfg.settings)
        )
      }
      ${optionalString (cfg.scanPath != null) (cgitrcLine "scan-path" cfg.scanPath)}

      # repository settings
      ${
        concatStrings (
          mapAttrsToList
          (url: settings: ''
            ${cgitrcLine "repo.url" url}
            ${
              concatStringsSep "\n" (
                mapAttrsToList (name: cgitrcLine "repo.${name}") settings
              )
            }
          '')
          cfg.repos
        )
      }

      # extra config
      ${cfg.extraConfig}
    '';

  onion = "q37hn7rhcbqiirapcx5bkgxzue5oqijdmjv55anfht2ne5hxxjxyhhyd.onion";

  cgitReverseProxy = ''
    handle_path /assets/* {
      root * ${config.services.cgit.radicle.package}/cgit
      file_server
    }
    handle_path /x/* {
      root * /var/www/git.leutgeb.xyz
      file_server
    }
    reverse_proxy unix/${config.services.fcgiwrap.socketAddress} {
      transport fastcgi {
        env SCRIPT_FILENAME ${config.services.cgit.radicle.package}/cgit/cgit.cgi
      }
    }
  '';
in {
  environment.etc."cgitrc".source = mkCgitrc;
  services = {
    nginx.enable = lib.mkForce false;

    fcgiwrap.enable = true;
    cgit.radicle = {
      enable = true;
      scanPath = "/var/lib/radicle/storage";
      package = pkgs.cgit-pink-radicle;
      settings = {
        enable-git-config = true;
        enable-blame = true;
        enable-commit-graph = false;
        enable-follow-links = true;
        enable-log-filecount = true;
        enable-log-linecount = true;
        enable-remote-branches = true;
        enable-tree-linenumbers = true;
        css = "/x/cgit.css";
        favicon = "/assets/favicon.ico";
        robots = "noindex, nofollow";
        clone-url = "rad:$CGIT_REPO_URL https://git.leutgeb.xyz/$CGIT_REPO_URL http://${onion}/$CGIT_REPO_URL";
        source-filter = "${config.services.cgit.radicle.package}/lib/cgit/filters/syntax-highlighting.py";
        about-filter = builtins.toString (pkgs.writeShellScript "about-filter.sh" ''
          case "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" in
              *.markdown|*.mdown|*.md|*.mkd) FROM='markdown'; ;;
              *.rst) FROM='rst'; ;;
              *.[1-9]) FROM='man'; ;;
              *.htm|*.html) exec cat; ;;
              *.dj) FROM='djot'; ;;
              *.txt|*) FROM='plain'; ;;
          esac

          ${lib.getExe pkgs.pandoc} --from=$FROM --to=html -
        '');
        logo = "/x/radicle.svg";
        #header = builtins.toString (pkgs.writeText "header" "Hey!");
        footer = builtins.toString (pkgs.writeText "footer" ''
          <div class="footer">generated by ${config.services.cgit.radicle.package.name}, ${pkgs.git.name}, radicle-${inputs.radicle.shortRev}</div>
        '');
        root-title = "Radicle Repository Browser 🔎📜";
        root-desc = "rad node connect z6MkocYY4dgMjo2YeUEwQ4BP4AotL7MyovzJCPiEuzkjg127@seed.leutgeb.xyz:8776";
        snapshots = "tar.gz tar.xz tar.zst zip";
        root-readme = builtins.toString (pkgs.runCommand "root-readme.html" {
            nativeBuildInputs = [pkgs.pandoc];
          } ''
            pandoc --from=markdown --to=html --output=$out ${./about-cgit.md}
          '');
      };
    };
    radicle = {
      enable = true;
      httpd.args = "--listen 127.0.0.1:${port}";
      settings.node.alias = "leutgeb.xyz";
    };
    caddy = {
      virtualHosts."seed.leutgeb.xyz" = {
        # For Caddy ≥ 2.8 use `file.*` replacements, see
        # <https://github.com/caddyserver/caddy/pull/5463>
        extraConfig = ''
          handle_path /* {
            reverse_proxy :${port}
          }
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
            resolvers 1.1.1.1
          }
          encode zstd
        '';
      };
      virtualHosts."git.leutgeb.xyz".extraConfig = cgitReverseProxy;
      virtualHosts."http://${onion}".extraConfig = cgitReverseProxy;
    };
  };
}
