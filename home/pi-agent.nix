{ pkgs, lib, inputs, ... }:
{
  home.file.".pi/agent/skills".source = ../skills;

  programs.pi = {
    enable = true;
    package = inputs.pi-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    provider = "openrouter";
    model = "nvidia/nemotron-3-nano-30b-a3b:free";

    # Native pi theme (seed value — switchable at runtime via /settings)
    theme = "catppuccin-mocha";

    auth.openrouter = {
      type = "api_key";
      key = "!op read 'op://Development/OpenRouter API Key/credential' --no-newline";
    };

    customProviders.ollama-local = {
      name = "Ollama (local)";
      baseUrl = "http://localhost:11434/v1";
      apiKey = "ollama";
      models = [
        { id = "qwen3.5:35b"; name = "Qwen 3.5 35B"; input = [ "text" ]; contextWindow = 131072; }
        { id = "nemotron-cascade-2:30b"; name = "Nemotron Cascade 2 30B"; input = [ "text" ]; contextWindow = 4096; }
        { id = "gemma4:26b"; name = "Gemma 4 26B"; input = [ "text" "image" ]; contextWindow = 131072; }
        { id = "gemma4:31b"; name = "Gemma 4 31B"; input = [ "text" "image" ]; contextWindow = 131072; }
        { id = "qwen3.6:27b-coding-mxfp8"; name = "Qwen 3.6 27B Coding"; input = [ "text" ]; contextWindow = 131072; }
      ];
    };

    packages = [
      "npm:pi-mcp-adapter"
      "npm:pi-subagents"
      "npm:pi-web-access"
      "npm:pi-lens"
      "npm:context-mode"
      "npm:pi-tool-display"
      "npm:pi-thinking-steps"
      "git:github.com/otahontas/pi-coding-agent-catppuccin"
    ];

    mutableSettings = true;

    # Sync pi theme with themeup system via PI_THEME env var
    # This overrides pi's native theme setting on each launch to match system appearance
    preLaunchHook = ''
      if [[ -n "$PI_THEME" ]]; then
        ${pkgs.jq}/bin/jq --arg t "catppuccin-$PI_THEME" '.theme = $t' "$settings_file" > "$settings_file.tmp" \
          && mv "$settings_file.tmp" "$settings_file"
      fi
    '';
  };

  # Catppuccin/themeup integration (dotfiles-specific, not part of module)
  programs.zsh.initContent = lib.mkOrder 1500 ''
    theme_pi() {
      local theme="$1"
      case "$theme" in
        mocha)     export PI_THEME="mocha" ;;
        latte)     export PI_THEME="latte" ;;
        frappe)    export PI_THEME="frappe" ;;
        macchiato) export PI_THEME="macchiato" ;;
        *)         export PI_THEME="mocha" ;;
      esac
    }
    THEME_FUNCS+=("theme_pi")
  '';
}
