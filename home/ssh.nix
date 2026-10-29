{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # The devbox signs and authenticates with its own keys, so never lend it this machine's agent.
    settings."devbox".ForwardAgent = false;

    settings."*" = {
      ForwardAgent = true;
      AddKeysToAgent = "no";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };

  home.shellAliases.ssh = "TERM=xterm-256color ssh";
}
