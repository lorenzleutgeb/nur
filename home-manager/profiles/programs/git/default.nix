{ pkgs, ... }:

{
  home.packages = with pkgs;
    with gitAndTools; [
      delta
      gh
      ghq
      git-crypt
      git-imerge
      git-lfs
      hub
      tig
    ];

  # xdg.configFile."git/config".text = builtins.readFile ./config;

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    includes = [
      {
        condition = "gitdir:~/src/git.sclable.com/";
        contents.user.email = "lorenz.leutgeb@sclable.com";
      }
      {
        condition = "gitdir:~/src/github.molgen.mpg.de/";
        contents.user.email = "lorenz@mpi-inf.mpg.de";
      }
      {
        condition = "gitdir:~/src/gitlab.mpi-klsb.mpg.de/";
        contents.user.email = "lorenz@mpi-inf.mpg.de";
      }
      {
        condition = "gitdir:~/src/gitlab.mpi-sws.org/";
        contents.user.email = "lorenz@mpi-inf.mpg.de";
      }
    ];

    lfs.enable = true;
    userName = "Lorenz Leutgeb";
    userEmail = "lorenz@leutgeb.xyz";

    ignores = [ ".dir-locals.el" ".direnv/" ".envrc" ];

    aliases = {
      month =
        "! git log --no-merges --since='last month' --author=$USER --reverse --pretty=format:'%cd %s %d' --date=short";
      yesterday =
        "! git log --no-merges --since='yesterday' --author=$USER --reverse --pretty=format:'%cd %s %d' --date=short";
      alias =
        "! git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ /";
      a = "add";
      b = "branch";
      bl = ''
        git for-each-ref --format="%(align:24,left)%(committername)%(end) %(committerdate:format:%F) %(objectname:short) %(refname:lstrip=3)" --sort=committerdate --sort=committername refs/remotes/origin'';
      ap = "add --patch";
      c = "commit";
      ca = "commit --amend";
      can = "commit --amend --no-edit";
      cd = "! cd $(git rev-parse --show-toplevel)";
      cn = "commit --no-verify";
      cp = "cherry-pick";
      cpc = "cherry-pick --continue";
      co = "checkout";
      cob = "checkout -b";
      coc = ''! f(){ git checkout "$1" && git clean -xfd; }; f'';
      d = "diff";
      ds = "diff --staged";
      f = "fetch";
      i = "!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi";
      il = ''! git config --local core.excludesfile "$HOME/gitignore"'';
      m = "merge";
      mm =
        "! git branch -m master main && git fetch origin && git branch -u origin/main main && git remote set-head origin -a";
      mff = "merge --ff-only";
      mr =
        "! sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
      p = "push";
      pf = "push --force-with-lease";
      pff = "push --force";
      pr =
        "!f() { remote=\${2-origin} ; git fetch $remote refs/pull/$1/head:#$1 ; } ; f";
      ll =
        "log --graph --decorate --show-signature --date=iso8601-strict --use-mailmap --abbrev-commit";
      l =
        "log --graph --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset' --abbrev-commit --date=relative";
      r = "rebase";
      rc = "rebase --continue";
      ri = "rebase --interactive";
      rb =
        "!grb() { git rebase -i $(git merge-base HEAD \${@:-sandbox}) ;}; grb";
      rh = "reset --hard";
      s = "status";
      who = "!gwho() { git log --pretty=%an $@ | sort | uniq ;}; gwho";
      tags = "tag -l";
    };

    extraConfig = {
      branch = {
        # Automatic remote tracking.
        autoSetupMerge = "always";
        # Automatically use rebase for new branches.
        autoSetupRebase = "always";
      };

      fetch = {
        prune = "true";
        recurseSubmodules = "true";
      };

      pull = { rebase = "true"; };

      push = { default = "current"; };

      help.autocorrect = "20";

      color.ui = "true";

      core = {
        pager = "delta";
        editor = "nvim";
        autocrlf = "input";
        commitGraph = "true";
      };

      interactive.diffFilter = "delta --color-only";

      diff = {
        submodule = "log";
        tool = "ediff";
      };

      difftool = { prompt = "false"; };

      rebase = {
        # Support fixup and squash commits.
        autoSquash = "true";
        # Stash dirty worktree before rebase.
        autoStash = "true";
      };

      /* [merge "npm-merge-driver"]
         	name = "Automatically merge npm lockfiles"
         	driver = "npm-merge-driver merge %A %O %B %P"

         [filter "media"]
         	clean = git media clean %f
         	smudge = git media smudge %f
         	required = true
         [filter "lfs"]
         	clean = git-lfs clean -- %f
         	smudge = git-lfs smudge -- %f
         	required = true
         [filter "gpg"]
         	clean = "gpg --encrypt --recipient EBB1C984 -o- %f | git-lfs clean -- %f"
         	smudge = "git-lfs smudge -- %f | gpg --decrypt --output %f"
      */

      init = { defaultBranch = "main"; };

      merge = {
        ff = "false";
        tool = "meld";
      };

      mergetool = {
        prompt = "false";
        keepBackup = "false";
      };

      # Reuse recorded resolutions.
      rerere = {
        enabled = "true";
        autoUpdate = "true";
      };

      delta = {
        theme = "Monokai Extended";
        features = "line-numbers decorations";
      };

      ghq = { root = "~/src"; };

      url = {
        "ssh://git@github.com/" = { pushInsteadOf = "https://github.com/"; };
        "ssh://git@gitlab.mpi-klsb.mpg.de/" = {
          insteadOf = "https://gitlab.mpi-klsb.mpg.de/";
        };
        "ssh://git@gitlab.mpi-sws.org/" = {
          insteadOf = "https://gitlab.mpi-sws.org/";
        };
        "ssh://git@githbu.molgen.mpg.de/" = {
          insteadOf = "https://github.molgen.mpg.de/";
        };
        "ssh://git@github.com/" = { insteadOf = "gh:"; };
        "ssh://git@github.com/lorenz.leutgeb/" = { insteadOf = "gh:ll/"; };
        "ssh://git@git.sclable.com/" = { insteadOf = "scl:"; };
        "ssh://git@git.sclable.com/lorenz.leutgeb/" = {
          insteadOf = "scl:ll/";
        };
      };
    };
  };
}
