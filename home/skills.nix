{ pkgs, inputs, ... }:
let
  validate-mermaid = pkgs.buildNpmPackage {
    pname = "validate-mermaid";
    version = "1.0.0";
    src = ../skills/mermaid/scripts;
    npmDepsHash = "sha256-95F2K8XM2XBwGqDcqy2zBu5PX4rMzIxaERdW+KTRfFg=";
    dontNpmBuild = true;
  };

  # Merged skills tree: my own ../skills, Matt Pocock's promoted skills, and pstack.
  skillsTree = pkgs.runCommand "agent-skills" { } ''
    mkdir -p "$out"

    # Base layer: my own skills (already flat <name>/SKILL.md).
    cp -RL ${../skills}/. "$out/"
    chmod -R u+w "$out"

    # Overlay: Matt Pocock's skills, flattening the bucket directories.
    # for bucket in engineering productivity; do
    #   for d in ${inputs.mattpocock-skills}/skills/"$bucket"/*; do
    #     [ -e "$d/SKILL.md" ] || continue
    #     name=$(basename "$d")
    #     rm -rf "$out/$name"
    #     cp -RL "$d" "$out/$name"
    #   done
    # done
    # chmod -R u+w "$out"

    # Overlay only pstack's skills. Do not copy its agents, automations, docs, or scripts.
    for d in ${inputs.pstack}/pstack/skills/*; do
      [ -e "$d/SKILL.md" ] || continue
      name=$(basename "$d")
      rm -rf "$out/$name"
      cp -RL "$d" "$out/$name"
    done
    chmod -R u+w "$out"
  '';
in
{
  home.packages = [ validate-mermaid ];

  _module.args.skillsTree = skillsTree;
}
