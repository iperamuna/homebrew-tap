cask "offload" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "1.0.0"
  sha256 arm:   "0c9ead9cc623964e4595e2bc0b700228a2bf5b21c9e90bb9f3244c902a7f881e",
         intel: "20002316ea3157a67bcb75d75f574b4cb210e3fbe3c7f4d8d620d9fd1684cdce"

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
