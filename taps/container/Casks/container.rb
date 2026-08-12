cask "container" do
  version "1.2.2"
  sha256 "f4c7e73f7203725a3512676dfd9ec6c6a98a37093b6fd4a1b0fdcfcb227e2118"

  url "https://github.com/apple/container/releases/download/#{version}/container-#{version}-installer-signed.pkg"
  name "container"
  desc "Run Linux containers as lightweight virtual machines on Apple silicon"
  homepage "https://github.com/apple/container"

  pkg "container-#{version}-installer-signed.pkg"

  uninstall pkgutil: "com.apple.container-installer"
end
