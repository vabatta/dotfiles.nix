# NOTE: the upstream release binary, because nixpkgs has no engram package.
# TODO: switch to the nixpkgs package once one lands.
{ lib, stdenvNoCC, fetchurl }:
let
  version = "3.6.0";
  # release asset and sha256 per platform, from the release's checksums.txt
  assets = {
    aarch64-darwin = { name = "darwin_arm64"; sha256 = "b1e565ad2a2f01beca936030d65ab79075808ecc81e1e16447040e32fa2c0753"; };
    x86_64-darwin = { name = "darwin_amd64"; sha256 = "41d74d7d61bd8a8929da85a3ed75dbcb16c18f30efff4675ad2f832c8f89898e"; };
    x86_64-linux = { name = "linux_amd64"; sha256 = "945fb471188826c251160947f8dda9fe148ba0dd095fa3453174fe7ab5c6479e"; };
    aarch64-linux = { name = "linux_arm64"; sha256 = "00a2d7645aa428e56c32c18b8de8bfa90d4c6e0f68c4d47bc82e3d6e3e77879d"; };
  };
  asset = assets.${stdenvNoCC.hostPlatform.system};
in
# static Go binary, so it is installed as is; stripping would break the macOS signature
stdenvNoCC.mkDerivation {
  pname = "engram";
  inherit version;
  src = fetchurl {
    url = "https://github.com/Gentleman-Programming/engram/releases/download/v${version}/engram_${version}_${asset.name}.tar.gz";
    inherit (asset) sha256;
  };
  sourceRoot = ".";
  dontFixup = true;
  installPhase = "install -Dm755 engram $out/bin/engram";
  meta = {
    description = "Persistent memory for AI coding agents";
    homepage = "https://github.com/Gentleman-Programming/engram";
    license = lib.licenses.mit;
    mainProgram = "engram";
    platforms = lib.attrNames assets;
  };
}
