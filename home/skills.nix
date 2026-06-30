{ pkgs, inputs, ... }:
let
  # validate-mermaid — validates Mermaid diagrams with the real mermaid.parse()
  # grammar (run headless via jsdom). Reads a diagram on stdin (or file args),
  # exits 0 silently when valid, or prints the parser error to stderr and exits 1.
  # Used by the mermaid skill to verify every diagram before it is delivered.
  # Regenerate npmDepsHash after changing skills/mermaid/scripts/package-lock.json:
  #   nix run nixpkgs#prefetch-npm-deps -- skills/mermaid/scripts/package-lock.json
  validate-mermaid = pkgs.buildNpmPackage {
    pname = "validate-mermaid";
    version = "1.0.0";
    src = ../skills/mermaid/scripts;
    npmDepsHash = "sha256-95F2K8XM2XBwGqDcqy2zBu5PX4rMzIxaERdW+KTRfFg=";
    dontNpmBuild = true;
  };

  # Merged skills tree: my own ../skills plus Matt Pocock's promoted skills.
  # His skills nest under bucket dirs (skills/engineering/<name>, skills/
  # productivity/<name>); Claude/pi/opencode want a flat <name>/SKILL.md layout,
  # so the bucket leaves are flattened to the top level. Sibling reference files
  # (GLOSSARY.md, *-FORMAT.md, scripts/) travel with each skill. Each agent
  # registers this tree itself in its own module (see _module.args.skillsTree).
  skillsTree = pkgs.runCommand "agent-skills" { } ''
    mkdir -p "$out"

    # Base layer: my own skills (already flat <name>/SKILL.md).
    cp -RL ${../skills}/. "$out/"

    # Overlay: Matt Pocock's skills, flattening the bucket directories.
    for bucket in engineering productivity; do
      for d in ${inputs.mattpocock-skills}/skills/"$bucket"/*; do
        [ -e "$d/SKILL.md" ] || continue
        name=$(basename "$d")
        if [ -e "$out/$name" ]; then
          echo "skill name collision: $name already exists" >&2
          exit 1
        fi
        cp -RL "$d" "$out/$name"
      done
    done

    chmod -R u+w "$out"
  '';
in
{
  # Custom packaging that backs the skills (built tools the skills shell out to,
  # and the merged skills tree). Each agent still registers the tree itself in its
  # own module; only this packaging lives here.
  home.packages = [ validate-mermaid ];

  # Expose the merged tree so each agent module can register it locally.
  _module.args.skillsTree = skillsTree;
}
