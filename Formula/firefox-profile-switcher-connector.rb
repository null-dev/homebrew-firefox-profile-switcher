class FirefoxProfileSwitcherConnector < Formula

    desc "The native component of the Profile Switcher for Firefox extension."
    homepage "https://github.com/null-dev/firefox-profile-switcher-connector"
    url "https://github.com/null-dev/firefox-profile-switcher-connector/archive/refs/tags/v0.0.9.tar.gz"
    sha256 "19b5049cf3f14cb0cec7e88799fc6c960e0194b16258d486b5324c02f60067a4"
    version "0.0.9"
    depends_on "rust" => :build
    depends_on "cmake" => :build

    @@manifest_name = "ax.nd.profile_switcher_ff.json"

    def install
      system "cargo", "build", "--release", "--bin", "firefox_profile_switcher_connector"

      bin_name = "ff-pswitch-connector"
      bin_path = File.expand_path(bin / bin_name)
      # Fix manifest
      orig_manifest_path = "manifest/manifest-mac.json"
      manifest_contents = File.read(orig_manifest_path)
      manifest_contents = manifest_contents.gsub(/(^\s*"path"\s*:\s*").*("\s*,?\s*$)/) { $1 + bin_path + $2 }
      File.open(orig_manifest_path, "w") {|f| f.puts manifest_contents }

      # Install files
      prefix.install orig_manifest_path => @@manifest_name
      bin.install "target/release/firefox_profile_switcher_connector" => bin_name
    end

    def caveats
      manifest_source = "#{HOMEBREW_CELLAR}/firefox-profile-switcher-connector/#{version}"
      manifest_destination = '"/Library/Application Support/Mozilla/NativeMessagingHosts"'
      <<~EOS
         The plugin manifest is installed but not linked in Firefox. Run the following two commands to link it:
             sudo mkdir -p #{manifest_destination}
             sudo ln -sf "#{manifest_source}/#{@@manifest_name}" #{manifest_destination}/#{@@manifest_name}
      EOS
    end

  end
