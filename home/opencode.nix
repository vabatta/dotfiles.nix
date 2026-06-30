{ pkgs, skillsTree, ... }:
let
  # Wrap the real opencode so the OpenRouter key is injected from 1Password at
  # launch, mirroring pi's deferred `!op read` behavior: no secret lands in the
  # Nix store, and `op` only runs (touch ID prompt) when opencode is launched.
  # opencode auto-activates the OpenRouter provider when OPENROUTER_API_KEY is set.
  #
  # This is set as `programs.opencode.package` (rather than a separate
  # home.packages entry) to avoid a bin/opencode collision, and because the
  # module crashes on `package = null` (it calls lib.versionAtLeast on a null
  # version in its deprecation-warning logic).
  opencodeWrapped = pkgs.writeShellScriptBin "opencode" ''
    export OPENROUTER_API_KEY="$(${pkgs._1password-cli}/bin/op read 'op://Development/OpenRouter API Key/credential' --no-newline)"
    exec ${pkgs.opencode}/bin/opencode "$@"
  '';
in
{
  programs.opencode = {
    enable = true;
    package = opencodeWrapped;

    settings = {
      # Same free tier as the pi setup; switchable at runtime via the model picker.
      model = "openrouter/nvidia/nemotron-3-nano-30b-a3b:free";
      # Updates are managed by nix, not opencode's self-updater.
      autoupdate = false;
    };

    tui = {
      # Follow macOS appearance automatically (replaces the themeup/PI_THEME hook).
      theme = "system";
    };

    # Merged skills tree (mine + Matt Pocock's), built in skills.nix.
    # Coerced to a store-path string — this option is path/string-typed, so a
    # bare derivation would make the module recurse into its attributes.
    skills = toString skillsTree;
  };
}
