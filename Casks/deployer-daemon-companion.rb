cask "deployer-daemon-companion" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "0.3.0"
  sha256 arm:   "18ec6395f5b24b6e8c8bcc958b5cb9b8114eed43f2acaf94ceb4d09253d02a88",
         intel: "6df91e5ae34ab07fa23130d27ed6a6d763a44fcdbe46a5c550f8d6b6b12a5132"

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
