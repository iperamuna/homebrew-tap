cask "offload" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "1.0.0"
  sha256 arm:   "5b7b5ef65997dee606b86a004690bf10ab1b1f9fc3ec69e0969afba0a288fc0e",
         intel: "a2b0f04f7a8438715dc37add828f71471c4754a3d8ae039362142b79f9a9ce56"

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
