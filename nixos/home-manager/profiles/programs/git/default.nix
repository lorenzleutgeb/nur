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
      ap = "add --patch";
      c = "commit";
      ca = "commit --amend";
      can = "commit --amend --no-edit";
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

      delta = { theme = "Monokai Extended"; };

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
        features = "side-by-side line-numbers decorations";
        syntax-theme = "ansi-light";
      };

      ghq = { root = "~/src"; };

      url = {
        "ssh://git@github.com/lorenzleutgeb" = {
          insteadOf = "https://github.com/lorenzleutgeb";
        };
      };
    };
  };
}
