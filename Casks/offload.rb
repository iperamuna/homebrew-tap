cask "offload" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "1.0.0"
  sha256 arm:   "e27088ecdc89da20a2e00cbcdad2d37c85fa0bf02bbfcbda074c5157e793d832",
         intel: "63b4a0157861c2ad3c09b26090a4052201ad4feef97fa5c825d1f4f09c62ab1e"

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
