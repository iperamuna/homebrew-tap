cask "deployer-daemon-companion" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "0.1.0"
  sha256 arm:   "0aed08026b808a0bc0c99cf8f889f008f9e6656a503515f393473f0a6abca794",
         intel: "8ee9114f2bb3abd8eef79259d1870b35610b56bef9e05dd6398484ccc66b9b0f"

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
