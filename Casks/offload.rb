cask "offload" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "1.1.1"
  sha256 arm:   "0157fd1281caa20fa381978976708dafa33f28cb82d3b6864f5c264d9cd8975a",
         intel: "237b794af5d092d52eb8dcb2d6bd093f11d21363f8e0c347b699af40973fc232"

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
