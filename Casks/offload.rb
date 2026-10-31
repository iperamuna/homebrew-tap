cask "offload" do
  arch arm: "aarch64", intel: "x64"
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "1.0.0"
  sha256 arm:   "ARM64_SHA256_HASH_HERE",
         intel: "INTEL_SHA256_HASH_HERE"

  url "https://github.com/iperamuna/offload/releases/download/v#{version}/Offload_#{version}_#{arch}.dmg"
  name "Offload"
  desc "Smart macOS drive space offloader and symlink manager"
  homepage "https://github.com/iperamuna/offload"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Offload.app"

  zap trash: [
    "~/.offload-internal",
    "~/Library/Application Support/com.indunilperamuna.offload",
    "~/Library/Preferences/com.indunilperamuna.offload.plist",
    "~/Library/Saved Application State/com.indunilperamuna.offload.savedState",
  ]
end
