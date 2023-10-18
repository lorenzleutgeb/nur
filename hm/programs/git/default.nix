{
  pkgs,
  config,
  ...
}: let
  sub = section: subsection: ''${section} "${subsection}"'';
  gitalias = import ./gitalias.nix;
in {
  home.packages = with pkgs;
  with gitAndTools; [
    delta
    ghq
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

    ignores = [".dir-locals.el" ".direnv/" ".envrc" ".mob" ".env"];

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
      il = ''! git config --local core.excludesfile "$HOME/gitignore"'';
      ll = "log --graph --decorate --show-signature --date=iso8601-strict --use-mailmap --abbrev-commit";
      l = "log --graph --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset' --abbrev-commit --date=relative";
      mff = "merge --ff-only";
      mm = "! git branch -m master main && git fetch origin && git branch -u origin/main main && git remote set-head origin -a";
      month = "! git log --no-merges --since='last month' --author=$USER --reverse --pretty=format:'%cd %s %d' --date=short";
      mr = "! sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
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

    extraConfig = {
      branch = {
        # Automatic remote tracking.
        autoSetupMerge = "always";
        # Automatically use rebase for new branches.
        autoSetupRebase = "always";
      };
      checkout = {
        defaultRemote = "origin";
        guess = true;
        thresholdForParallelism = 0;
      };
      color.ui = true;
      core = {
        pager = "delta";
        editor = "nvim";
        autocrlf = "input";
        commitGraph = true;
      };
      delta = {
        theme = "Monokai Extended";
        features = "line-numbers decorations side-by-side";
        navigate = true;
      };
      diff = {
        submodule = "log";
        tool = "ediff";
      };
      difftool = {prompt = "false";};
      fetch = {
        negotiationAlgorithm = "skipping";
        prune = true;
        parallel = 0;
        recurseSubmodules = true;
        writeCommitGraph = true;
      };
      ghq = {root = "~/src";};
      help.autocorrect = "20";
      interactive.diffFilter = "delta --color-only";
      init = {defaultBranch = "main";};
      merge = {
        ff = false;
        guitool = "meld";
        # TODO: Switch to zdiff3.
        conflictStyle = "diff3";
      };
      mergetool = {
        prompt = false;
        keepBackup = "false";
      };
      log.date = "iso8601";
      pull.ff = "only";
      push = {default = "current";};
      rebase = {
        # Support fixup and squash commits.
        autoSquash = true;
        # Stash dirty worktree before rebase.
        autoStash = true;
      };
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
      sendemail = {
        smtpEncryption = "tls";
        smtpServerPort = 587;
        annotate = true;
      };
      status = {showStash = true;};
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
