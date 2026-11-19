{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      # Never lend this machine's agent: a remote box could sign with every key 1Password serves, maybe with no prompt.
      # caraway has its own GitHub keys, and no host here needs the Mac's. For a one-off: ssh -A <host>.
      ForwardAgent = false;
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
