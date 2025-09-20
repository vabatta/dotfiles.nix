{ config, ... }:
{
  programs.git = {
    enable = true;
    userName = "vabatta";
    userEmail = "2137077+vabatta@users.noreply.github.com";
    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERFqyE4flUaslGeGLB/O0KXoPfi+Azp35X8UJ0oAE3U";
      signByDefault = true;
    };

    lfs.enable = true;

    ignores = [
      # Created by https://www.toptal.com/developers/gitignore/api/macos
      # Edit at https://www.toptal.com/developers/gitignore?templates=macos

      # macOS
      # General
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"

      # Icon must end with two \r
      "Icon"

      # Thumbnails
      "._*"

      # Files that might appear in the root of a volume
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"

      # Directories potentially created on remote AFP share
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"

      # macOS Patch
      # iCloud generated files
      "*.icloud"

      # End of https://www.toptal.com/developers/gitignore/api/macos
    ];

    extraConfig = {
      github = {
        user = "vabatta";
      };
      init = {
        defaultBranch = "main";
      };
      include = {
        # A local gitconfig, outside of version control.
        # If the file doesn't exist it is silently ignored
        path = "${config.xdg.configHome}/git/config.local";
      };
      push = {
        # push will only do the current branch, not all branches
        default = "current";
      };
      branch = {
        # set up 'git pull' to rebase instead of merge
        autosetuprebase = "always";
      };
      pull = {
        rebase = true;
      };
      diff = {
        renames = "copies";
        mnemonicprefix = true;
        compactionHeuristic = true;
      };
      difftool = {
        prompt = false;
      };
      apply = {
        # do not warn about missing whitespace at EOF
        whitespace = "nowarn";
      };
      core = {
        whitespace = "cr-at-eol";
        pager = "less -R";
      };
      rerere = {
        enabled = true;
      };
      grep = {
        extendRegexp = true;
        lineNumber = true;
      };
      rebase = {
        instructionFormat = "[%an - %ar] %s";
        autoStash = true;
      };
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        interactive = "auto";
        ui = "auto";
      };
      safe = {
        directory = "*";
      };
    };

    aliases = {
      list-aliases = "!git config -l | grep alias | cut -c 7-";

      # shortcuts
      aa = "add --all";
      co = "checkout";
      cb = "checkout -b";
      br = "branch";
      s = "status -sb";
      st = "status";
      cbr = "rev-parse --abbrev-ref HEAD";
      ci = "commit";
      cm = "commit -m";
      ca = "commit --amend";
      cane = "commit --amend --no-edit";
      d = "diff";
      ds = "diff --staged";
      l = "log --graph --pretty=format:'%Cred%h%Creset %C(bold blue)%an%C(reset) - %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
      lg = "log --oneline --graph --decorate --all";
      pl = "pull";
      ps = "push";
      pf = "push --force-with-lease";
      rb = "rebase";
      rbc = "rebase --continue";
      rbi = "rebase -i";
      rs = "reset";
      rsh = "reset --hard";
      si = "submodule init";
      su = "submodule update";
      sub = "!git submodule sync && git submodule update";

      # stats
      # Show the committers in the last 100 commits, sorted by who has commited the most
      review = "!git log --no-merges --pretty=%an | head -n 100 | sort | uniq -c | sort -nr";
      # Show number of commits per contributor, sorted by count
      count = "shortlog -sn";
      # Same as count, but includes email addresses
      top = "shortlog -sne";
      # Show files ordered by number of commits (churn)
      churn = "!f() { git log --all -M -C --name-only --format='format:' \"$@\" | sort | grep -v '^$' | uniq -c | sort | awk 'BEGIN {print \"count\\tfile\"} {print $1 \"\\t\" $2}' | sort -g; }; f";
      # Count total lines of code tracked by Git
      loc = "!git ls-files | xargs wc -l";
      # Show summary of changes in current diff (files, insertions, deletions)
      changed = "diff --stat";
      # Show how many commits ahead/behind origin the current branch is
      ahead = "!git rev-list --left-right --count origin/$(git rev-parse --abbrev-ref HEAD)...HEAD";
      # Show commits you made today
      today = "!git log --since=midnight --author=\"$(git config user.name)\" --oneline";
      # Count number of files in current commit (HEAD)
      files = "!git ls-tree -r HEAD --name-only | wc -l";
      # Show total size in bytes of files in current commit
      size = "!git ls-tree -r HEAD --long | awk '{ sum += $4 } END { print sum }'";
      # Show total lines added and removed in repo history
      hist = "!git log --pretty=tformat: --numstat | awk '{ added += $1; removed += $2 } END { print \"Added:\", added, \"Removed:\", removed }'";
      # Show last commit
      last = "log -1";
      # Blame a file with emails (usage: git who <file>)
      who = "blame -e";
      # Show date and author of oldest commit
      age = "!git log --pretty=format:\"%ad %an\" --date=short | sort | head -1";
      # show the most recently touched branches
      recent = "!git for-each-ref --sort='-committerdate' --format='%(color:red)%(refname)%(color:reset)%09%(committerdate)' refs/heads | sed -e 's-refs/heads/--' | less -XFR";
      latest = "!git for-each-ref --sort='-committerdate' --format='%(color:red)%(refname)%(color:reset)%09%(committerdate)' refs/remotes | sed -e 's-refs/remotes/origin/--' | less -XFR";

      # utils
      # Clones a bare repository and sets up the current directory as its first worktree for use with 'git worktree'
      bare-clone = "!f() { REPO=$1; BARE_DIR=\".bare\"; git clone --bare \"$REPO\" \"$BARE_DIR\" && cd \"$BARE_DIR\" && git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*' && cd - > /dev/null && echo \"gitdir: $BARE_DIR\" > .git; }; f";
      # Stage only new lines from my local changes
      addnw = "!sh -c 'git diff -U0 -w --no-color \"$@\" | git apply --cached --ignore-whitespace --unidiff-zero -'";
      # Output last sha
      last-sha = "!sh -c 'printf %s \"$(git rev-parse \${1:-HEAD})\"'";
      # Undo last commit locally
      undo = "reset --soft HEAD~1";
      # Rebase the current branch with changes from upstream remote
      update = "!git fetch upstream && git rebase upstream/`git rev-parse --abbrev-ref HEAD`";
      # Assume aliases (allow tracked files to be changed without be tracked locally)
      assume = "update-index --assume-unchanged";
      unassume = "update-index --no-assume-unchanged";
      assumed = "!git ls-files -v | grep ^h | cut -c 3-";
      unassumeall = "!git assumed | xargs git update-index --no-assume-unchanged";
      delete-merged-branches = "!f() { git checkout --quiet master && git branch --merged | grep --invert-match '\\*' | xargs -n 1 git branch --delete; git checkout --quiet @{-1}; }; f";
    };
  };

  home.shellAliases = {
    g = "git";
  };
}
