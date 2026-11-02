cask "deployer-daemon-companion" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "0.1.0"
  sha256 arm:   "d9aa0048c1f3cc2d4437fbcb0a4352f965fd11d7efdfd83e41bc9aafdc8f7425",
         intel: "450f6cd47a75c9b54edf1338ff113f13919b2d0a00ab0b59b6fa37dc8bbd70df"

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
