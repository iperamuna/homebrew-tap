cask "offload" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "1.2.0"
  sha256 arm:   "107648dbd26b0e60e44b328c0e7dbde66b64caa199a613daa03519b6ef86a1b6",
         intel: "2f54bd096817dd1f974974ac115bd51289a07b57f446c7a3ea17bb37f6f202f0"

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
