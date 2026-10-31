cask "offload" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "1.0.0"
  sha256 arm:   "9de4bacd12b3d86b44bd6cc609d7691ab44a7ae63fd8930a9e90b3dd3111136c",
         intel: "96f18bcaac332959f46ce85d086807d49b4adca98503509c913fbdb8327b7b9d"

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
