cask "deployer-daemon-companion" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "0.4.0"
  sha256 arm:   "fcbf256b520113c52dded807253604058b4ef32ee221e4b34af7842e78fa9846",
         intel: "9a1328578b8eaab201b61834a99f0d7dad598ef81b8026bd66ca1d88879725a5"

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

  preflight_steps do
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

  postflight_steps do
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

  uninstall_preflight_steps do
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
