{ lib, buildNpmPackage, fetchFromGitHub, pkg-config, cairo, pango, pixman, libjpeg, giflib, librsvg, python3, nodejs }:

buildNpmPackage rec {
  pname = "pi-coding-agent";
  version = "0.65.2";

  src = fetchFromGitHub {
    owner = "badlogic";
    repo = "pi-mono";
    rev = "v${version}";
    hash = "sha256-nHCQboyRT8k2t7dD0knmQSaUciQua17518CG/3jC7Rg=";
  };

  # all deps live in the root package-lock.json (workspace monorepo)
  npmDepsHash = "sha256-ZFrOh2P2kkKz4kwD153ltPX852sS1JcTCvSLYwZbyoo=";

  # canvas native addon deps
  nativeBuildInputs = [ pkg-config python3 ];
  buildInputs = [ cairo pango pixman libjpeg giflib librsvg ];

  # build all workspace packages in dependency order before coding-agent
  buildPhase = ''
    runHook preBuild
    for ws in packages/jiti packages/ai packages/agent packages/tui packages/coding-agent; do
      if [ -f "$ws/package.json" ]; then
        echo "building workspace: $ws"
        if [ "$ws" = "packages/coding-agent" ]; then
          # coding-agent is required — fail if it doesn't build
          npm --workspace="$ws" run build
        else
          # other workspaces are dependencies; warn if they fail but continue
          npm --workspace="$ws" run build || echo "Warning: $ws build failed, continuing..."
        fi
      fi
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    local pkg="packages/coding-agent"
    local mod="$out/lib/node_modules/@mariozechner/pi-coding-agent"
    mkdir -p "$mod" "$out/bin"
    cp -r "$pkg/dist" "$pkg/package.json" "$mod/"
    # copy runtime node_modules (symlinks resolved)
    cp -rL node_modules "$mod/node_modules"
    makeWrapper ${nodejs}/bin/node "$out/bin/pi" \
      --add-flags "$mod/dist/cli.js" \
      --set DISABLE_AUTOUPDATER 1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Minimal coding agent CLI (read, bash, edit, write) with session management";
    homepage = "https://github.com/badlogic/pi-mono";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "pi";
  };
}
