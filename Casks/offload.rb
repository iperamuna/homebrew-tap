cask "offload" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "1.2.1"
  sha256 arm:   "c962afc341d06305fb184410ad5a0e284f78e35deafccebef4a3ad59ba9bca1e",
         intel: "fdcdbe591fae0fd512c3676428647220db9ff65354dea5c0d4510aa2374e56eb"

  url "https://github.com/iperamuna/offload/releases/download/v#{version}/Offload_#{version}_#{arch}.dmg"
  name "Offload"
  desc "Smart macOS drive space offloader and symlink manager"
  homepage "https://github.com/iperamuna/offload"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :monterey

  app "Offload.app"

  zap trash: [
    "~/.offload-internal",
    "~/Library/Application Support/com.indunilperamuna.offload",
    "~/Library/Preferences/com.indunilperamuna.offload.plist",
    "~/Library/Saved Application State/com.indunilperamuna.offload.savedState",
  ]
end
