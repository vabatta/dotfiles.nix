{ ... }:
{
  programs.gh = {
    enable = true;

    settings = {
      editor = "nvim";
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        # PR shortcuts
        co = "pr checkout";
        pv = "pr view --web";
        pc = "pr create --web";
        pl = "pr list";
        ps = "pr status";
        pm = "pr merge --squash --delete-branch";

        # Issue shortcuts
        il = "issue list";
        iv = "issue view --web";
        ic = "issue create --web";
        is = "issue status";

        # Repo shortcuts
        rv = "repo view --web";
        rc = "repo clone";
        rf = "repo fork --clone";

        # Browse
        bw = "browse";
      };
    };
  };
}
