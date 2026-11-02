cask "deployer-daemon-companion" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "0.1.0"
  sha256 arm:   "48073229579c09a68943782a7ae4326c3979b2f3802e92b5efe78409c0542d77",
         intel: "9f376d450e3fe424628562a0ab247159a7509a88dcceee8b83f82be3e930dd99"

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
