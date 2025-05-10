{
  config,
  lib,
  pkgs,
  options,
  ...
}: let
  inherit
    (lib)
    concatStringsSep
    flatten
    generators
    getBin
    getExe
    getExe'
    intersperse
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  inherit
    (lib.types)
    attrsOf
    bool
    listOf
    nullOr
    oneOf
    package
    path
    str
    submodule
    ;

  inherit
    (builtins)
    map
    ;

  cfg = config.services.radicle-mirror;
  opt = options.services.radicle-mirror;

  radicleHome = config.home.homeDirectory + "/.radicle";
  storage = "${radicleHome}/storage";
in {
  meta.maintainers = with lib.maintainers; [lorenzleutgeb];

  options = {
    services.radicle-mirror = mkOption {
      type = attrsOf (submodule {
        options = {
          rid = mkOption {
            description = "Radicle Repository ID";
            example = "z42hL2jL4XNk6K8oHQaSWfMgCL7ji";
            type = str;
          };
          remote = mkOption {
            description = "Git repository to mirror to.";
            example = "git@example.com:example.git";
            type = str;
          };
          args = mkOption {
            description = "Arguments to pass to `git fetch`.";
            example = ["--force" "--verbose"];
            default = ["--force" "--prune" "--porcelain" "--quiet"];
            type = listOf str;
          };
          refs = {
            watch = mkOption {
              description = "Git references to watch for changes. Only refnames, no patterns.";
              default = ["refs/heads/main"];
              type = listOf str;
            };
            mirror = mkOption {
              description = "Git refspec patterns to mirror.";
              default = ["refs/heads/*:refs/heads/*" "refs/tags/*:refs/tags/*"];
              type = listOf str;
            };
          };
          nodes = mkOption {
            type = attrsOf (submodule ({config, ...}: {
              options = {
                alias = mkOption {
                  description = "First path component(s) for references in this node's namespace. A short name that describes the node.";
                  example = "bob";
                  type = nullOr str;
                };
                refspecs = mkOption {
                  description = "Patterns that will map the namespace of the node into the canonical one.";
                  default =
                    if config.alias == null
                    then []
                    else ["refs/heads/*:refs/heads/${config.alias}/*" "refs/tags/*:refs/tags/${config.alias}/*"];
                  type = listOf str;
                };
              };
            }));
            default = {};
          };
        };
      });
    };
  };

  config = {
    systemd.user = let
      unit = rid: remote: {
        Description = "Mirror ${rid} to ${remote}";
        SourcePath = ./.;
        ConditionDirectoryNotEmpty = storage;
      };
    in {
      paths =
        lib.mapAttrs' (rid: {
          refs,
          remote,
          ...
        }: {
          name = "radicle-mirror-${rid}";
          value = {
	    Install.WantedBy = ["paths.target"];
            Unit = unit rid remote;
            Path.PathChanged = map (ref: "${storage}/${rid}/${ref}") refs.watch;
          };
        })
        cfg;

      services =
        lib.mapAttrs' (rid: {
          args,
          refs,
          nodes,
          remote,
          ...
        }: {
          name = "radicle-mirror-${rid}";
          value = {
	    Install = {
	      WantedBy = ["default.target"];
	    };
            Unit = (unit rid remote);
            Service = {
              Type = "oneshot";
              ExecStart =
                concatStringsSep " "
                ([(lib.getExe pkgs.git) "push"]
                  ++ args
                  ++ [remote]
                  ++ refs.mirror ++ (flatten (mapAttrsToList (id: {refspecs, ...}: map (spec: "refs/namespaces/${id}/${spec}") refspecs) nodes)));
              WorkingDirectory = "${storage}/${rid}";
              Environment = ["PATH=${getBin pkgs.openssh}/bin"];
	      Restart = "on-failure";
	      RestartSec = "10s";
	      RestartSteps = "5";
	      RestartMaxDelaySec = "5min";
            };
          };
        })
        cfg;
    };
  };
}
