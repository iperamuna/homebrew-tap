cask "deployer-daemon-companion" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "0.2.2"
  sha256 arm:   "ba6e586bd811998c3a3ccb87ddf75c24cc9503c68ab9743a5e7692b7de85e1ad",
         intel: "3791784a3218731111181d0720811e691854a33b24a98641687b150c917a3f83"

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

  preflight do
    # Check if app is running before Homebrew moves the new .app into /Applications
    is_running = system_command("/usr/bin/pgrep",
                                args: ["-f", "deployer-daemon-companion"],
                                must_succeed: false).status.success?

    if is_running
      File.write("#{staged_path}/.was_running", "1")
      system_command "/usr/bin/pkill",
                     args: ["-f", "deployer-daemon-companion"],
                     must_succeed: false
    end
  end

  postflight do
    app_path = "#{appdir}/Deployer Daemon Companion.app"

    # 1. Remove macOS quarantine attribute (prevents "damaged app" / Gatekeeper warning)
    system_command "/usr/bin/xattr",
                   args: ["-cr", app_path],
                   must_succeed: false

    # 2. Re-apply ad-hoc codesign requirement with stable bundle identifier
    system_command "/usr/bin/codesign",
                   args: [
                     "-s", "-",
                     "-f",
                     "--deep",
                     "-i", "com.deployerdaemon.companion",
                     "-r=designated => identifier \"com.deployerdaemon.companion\"",
                     app_path,
                   ],
                   must_succeed: false

    # 3. If the app was running prior to the upgrade, launch it
    if File.exist?("#{staged_path}/.was_running")
      system_command "/usr/bin/open",
                     args: [app_path],
                     must_succeed: false
    end
  end

  uninstall_preflight do
    system_command "/usr/bin/pkill",
                   args: ["-f", "deployer-daemon-companion"],
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/com.deployerdaemon.companion",
    "~/Library/Preferences/com.deployerdaemon.companion.plist",
    "~/Library/Saved Application State/com.deployerdaemon.companion.savedState",
  ]
end
