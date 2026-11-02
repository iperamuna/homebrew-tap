cask "deployer-daemon-companion" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "0.2.0"
  sha256 arm:   "c2bca1f898f426e0d4f719a8286fcce9502ed7b432678313125b485efdaf96ad",
         intel: "3ff879d93e5649732b360218143d97687403a02ff539900b9a46db8ab23bec66"

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
    "~/Library/Application Support/com.deployerdaemon.companion",
    "~/Library/Preferences/com.deployerdaemon.companion.plist",
    "~/Library/Saved Application State/com.deployerdaemon.companion.savedState",
  ]
end
