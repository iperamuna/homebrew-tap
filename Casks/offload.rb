cask "offload" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "1.1.0"
  sha256 arm:   "9e662da40e8ec59ce2cc8643673b3f76d08acffa70f0df1f76c7b07b98d9f449",
         intel: "ce7b0ed23e1b09f198e36389cfb2d4b2ee602e01137991189602e170ecbfa26e"

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
