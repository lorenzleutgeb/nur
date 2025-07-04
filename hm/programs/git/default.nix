{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.attrsets) recursiveUpdate;

  sub = section: subsection: ''${section} "${subsection}"'';
  gitalias = import ./gitalias.nix;
in {
  home.packages = with pkgs.gitAndTools; [
    ghq
    git-absorb
    git-crypt
    git-imerge
    tig
  ];

  home.sessionVariables = {
    "GITHUB_USER" = "lorenzleutgeb";
    "SCL_BASE" = "${config.home.homeDirectory}/src/sclable.com}";
    "GH_BASE" = "${config.home.homeDirectory}/src/github.com}";
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    lfs.enable = true;
    userName = "Lorenz Leutgeb";
    userEmail = "lorenz@leutgeb.xyz";

    difftastic.enable = true;

    ignores = [
      "*.orig"
      ".dir-locals.el"
      ".mob"
      "/.direnv/"
      "/.env"
      "/.envrc"
      "/result"
      "__pycache__"
      "*.pdf"
      "*.o"
      "*.a"
      "*.so"
    ];

    aliases = {
      inherit (gitalias) a ap b c ca cane co cob cp cpc d ds m;

      can = gitalias.cane;

      alias = "! git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ /";
      bl = ''
        git for-each-ref --format="%(align:24,left)%(committername)%(end) %(committerdate:format:%F) %(objectname:short) %(refname:lstrip=3)" --sort=committerdate --sort=committername refs/remotes/origin'';
      cd = "! cd $(git rev-parse --show-toplevel)";
      cn = "commit --no-verify";
      coc = ''! f(){ git checkout "$1" && git clean -xfd; }; f'';
      i = "!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi";
      ll = "log --graph --decorate --show-signature --date=iso8601-strict --use-mailmap --abbrev-commit";
      l = "log --graph --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset' --abbrev-commit --date=relative";
      mff = "merge --ff-only";
      mm = "! git branch -m master main && git fetch origin && git branch -u origin/main main && git remote set-head origin -a";
      month = "! git log --no-merges --since='last month' --author=$USER --reverse --pretty=format:'%cd %s %d' --date=short";
      mr = "! sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
      pam = "!f() { branch=\"$(git rev-parse --abbrev-ref HEAD)\" ; git checkout --detach ; git commit $@ ; git push self HEAD:refs/patches ; git checkout \"$branch\" ; }; f";
      p = "push";
      pf = "push --force-with-lease";
      pff = "push --force";
      pr = "!f() { remote=\${2:-origin} ; git fetch $remote refs/pull/$1/head:#$1 ; } ; f";
      r = "rebase";
      rb = "!grb() { git rebase -i $(git merge-base HEAD \${@:-sandbox}) ;}; grb";
      rc = "rebase --continue";
      rh = "reset --hard";
      ri = "rebase --interactive";
      rs = ''
        !grs() { git remote show ''${1:-origin} | grep -vE "\stracked$" ;}; grs'';
      s = "status --short --branch";
      suffix = "!gsuffix() { mv -v \${GIT_PREFIX}\${1} \${GIT_PREFIX}\${1}-$(git describe --abbrev=\${2:-4} --always --dirty) ;}; gsuffix";
      tags = "tag -l";
      who = "!gwho() { git log --pretty=%an $@ | sort | uniq ;}; gwho";
      yesterday = "! git log --no-merges --since='yesterday' --author=$USER --reverse --pretty=format:'%cd %s %d' --date=short";
    };

    attributes = [
      "*.* diff=difft"
    ];

    extraConfig =
      {
        ghq.root = "~/src";

        delta = {
          theme = "Monokai Extended";
          features = "line-numbers decorations side-by-side";
          navigate = true;
        };
      }
      // {
        branch = {
          # Automatic remote tracking.
          autoSetupMerge = "always";
          # Automatically use rebase for new branches.
          autoSetupRebase = "always";
          sort = "-committerdate";
        };

        checkout = {
          defaultRemote = "origin";
          guess = true;
          thresholdForParallelism = 0;
        };

        core = {
          editor = "nvim";
          autocrlf = "input";
          commitGraph = true;
        };

        column.ui = "auto";

        commit.verbose = true;

        diff = {
          algorithm = "histogram";
          colormoved = true;
          mnemonicPrefix = true;
          renames = true;
        };

        difftool.prompt = "false";

        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
          negotiationAlgorithm = "skipping";
          parallel = 0;
          recurseSubmodules = true;
          writeCommitGraph = true;
        };

        help.autocorrect = "prompt";

        init.defaultBranch = "main";

        log.date = "iso8601";

        merge = {
          ff = false;
          guitool = "meld";
          conflictStyle = "zdiff3";
        };

        mergetool = {
          prompt = false;
          keepBackup = "false";
        };

        pager.difftool = "true";

        pull = {
          rebase = true;
          ff = "only";
        };

        push = {
          default = "current";
          autoSetupRemote = true;
        };

        rerere = {
          enabled = true;
          autoupdate = true;
        };

        rebase = {
          # Support fixup and squash commits.
          autoSquash = true;
          # Stash dirty worktree before rebase.
          autoStash = true;
          updateRefs = true;
          missingCommitsCheck = "error";
        };

        sendemail = {
          smtpEncryption = "tls";
          smtpServerPort = 587;
          annotate = true;
        };

        status.showStash = true;

        tag.sort = "version:refname";

        url = let
          mk = {
            base,
            short,
          }: {
            name = "ssh://git@${base}";
            value = {
              # See <https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf>.
              insteadOf = short;
              # See <https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtpushInsteadOf>.
              pushInsteadOf = "https://${base}";
            };
          };
        in
          builtins.listToAttrs (map mk [
            {
              short = "gh:";
              base = "github.com/";
            }
            {
              short = "gh:ll/";
              base = "github.com/lorenzleutgeb/";
            }
            {
              short = "scl:";
              base = "git.sclable.com/";
            }
            {
              short = "scl:ll/";
              base = "git.sclable.com/lorenz.leutgeb/";
            }
          ]);

        "${sub "filter" "gpg"}" = {
          clean = "gpg --encrypt --recipient EBB1C984 -o- %f | git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f | gpg --decrypt --output %f";
        };

        "${sub "merge" "npm-merge-driver"}" = {
          name = "Automatically merge npm lockfiles";
          driver = "npm-merge-driver merge %A %O %B %P";
        };

        "${sub "lfs" "customtransfer.ipfs"}" = {
          path = "/home/lorenz/src/github.com/lorenzleutgeb/git-lfs-ipfs/transfer.sh";
          concurrent = false;
        };
        "${sub "lfs" "extension.ipfs"}" = {
          clean = "/home/lorenz/src/github.com/lorenzleutgeb/git-lfs-ipfs/clean.sh %f";
          smudge = "/home/lorenz/src/github.com/lorenzleutgeb/git-lfs-ipfs/smudge.sh %f";
        };
      };

    includes = [
      {
        condition = "gitdir:~/src/git.sclable.com/";
        contents.user.email = "lorenz.leutgeb@sclable.com";
      }
    ];
  };
}
