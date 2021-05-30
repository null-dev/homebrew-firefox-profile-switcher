class FirefoxProfileSwitcherConnector < Formula

    desc "The native component of the Profile Switcher for Firefox extension."
    homepage "https://github.com/null-dev/firefox-profile-switcher-connector"
    url "https://github.com/null-dev/firefox-profile-switcher-connector/archive/refs/tags/v0.0.6.tar.gz"
    sha256 "40f0429f2aeebd128072a75674e132477ef1f16ce03d77704fa55395624a62fc"
    version "0.0.6"
    depends_on "rust" => :build

    @@manifest_name = "ax.nd.profile_switcher_ff.json"

    def install
      system "cargo", "build", "--release", "--bin", "firefox_profile_switcher_connector"
      prefix.install "manifest/manifest-mac.json" => @@manifest_name
      bin.install "target/release/firefox_profile_switcher_connector" => "ff-pswitch-connector"
    end

    def caveats
      manifest_source = "#{HOMEBREW_CELLAR}/firefox-profile-switcher-connector/#{version}"
      manifest_destination = "~/Library/Application Support/Mozilla/NativeMessagingHosts"
      <<~EOS
         The plugin manifest is installed but not linked in Firefox. Run the following two commands to link it:
             mkdir -p "#{manifest_destination}"
             ln -sf "#{manifest_source}/#{@@manifest_name}" "#{manifest_destination}/#{@@manifest_name}"
      EOS
    end

  end
