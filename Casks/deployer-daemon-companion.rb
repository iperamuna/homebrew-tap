cask "deployer-daemon-companion" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "0.2.3"
  sha256 arm:   "6065368c02ab48f2dfa0c32b8d450c64c77ed352c660ad14b4fe19e6f915b022",
         intel: "9575854b1dde71a2f4d57745f545ce847f19d7557b48694df64ff7b45cfc4263"

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
