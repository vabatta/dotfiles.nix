{ pkgs, hostUsername, ... }:
{
  environment.systemPackages = [ pkgs.ollama ];

  launchd.agents.ollama = {
    serviceConfig = {
      Label = "dev.ollama.ollama";
      ProgramArguments = [ "${pkgs.ollama}/bin/ollama" "serve" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/Users/${hostUsername}/.local/state/ollama/ollama.log";
      StandardErrorPath = "/Users/${hostUsername}/.local/state/ollama/ollama.log";
      EnvironmentVariables = {
        HOME = "/Users/${hostUsername}";
      };
    };
  };
}
