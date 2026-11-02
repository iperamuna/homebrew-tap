cask "deployer-daemon-companion" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "0.1.0"
  sha256 arm:   "c962afc341d06305fb184410ad5a0e284f78e35deafccebef4a3ad59ba9bca1e",
         intel: "fdcdbe591fae0fd512c3676428647220db9ff65354dea5c0d4510aa2374e56eb"

  url "https://github.com/iperamuna/deployer-daemon-companion-releases/releases/download/v#{version}/Deployer_Daemon_Companion_#{version}_#{arch}.dmg"
  name "Deployer Daemon Companion"
  desc "System tray companion application for Deployer Daemon"
  homepage "https://github.com/iperamuna-siyaludeio/deploy-daemon-companion"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on :macos

  app "Deployer Daemon Companion.app"

  zap trash: [
    "~/Library/Application Support/com.indunilperamuna.deployerdaemon.companion",
    "~/Library/Preferences/com.indunilperamuna.deployerdaemon.companion.plist",
    "~/Library/Saved Application State/com.indunilperamuna.deployerdaemon.companion.savedState",
  ]
end
