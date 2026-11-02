cask "deployer-daemon-companion" do
  arch arm: "Apple_Silicon", intel: "Apple_Intel"

  version "0.2.1"
  sha256 arm:   "209b663fe177e58b27e88ed1d52d7f03e720340bbe066ac25c95643aedc2d5d6",
         intel: "7a8d73b7e2f38c0f546eb5121cbc267f5ab6a864a192cb9db36df9aa9d267f0a"

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
