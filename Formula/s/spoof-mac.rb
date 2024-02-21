class SpoofMac < Formula
  include Language::Python::Virtualenv

  desc "Spoof your MAC address in macOS"
  homepage "https://github.com/feross/SpoofMAC"
  url "https://files.pythonhosted.org/packages/9c/59/cc52a4c5d97b01fac7ff048353f8dc96f217eadc79022f78455e85144028/SpoofMAC-2.1.1.tar.gz"
  sha256 "48426efe033a148534e1d4dc224c4f1b1d22299c286df963c0b56ade4c7dc297"
  license "MIT"
  revision 4
  head "https://github.com/feross/SpoofMAC.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28e09a919eab56366ef28e7bcbf040beba2bba7ad1f532f2576814ac9849d7be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35531ac6280cc7a571b3c76550d9d85ef026be92ef41740b4bb6eb11875099bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b2a3899d35738983c302172c76042d59e7c3ff28ba4e0a44939545f75dadf50"
    sha256 cellar: :any_skip_relocation, sonoma:         "3acddac5532a8c70d48973167dee1bf80d5d722896d5c49c7c8860f83e06612d"
    sha256 cellar: :any_skip_relocation, ventura:        "44485ac201f5a4fde279758e03608e39adf7c17aaf6f1e3f9676bb5fe3f7c567"
    sha256 cellar: :any_skip_relocation, monterey:       "248c51e15362aa0d6c6a1d4821f91534fdda956e344efad1144a028623662baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8eba81d41a64fab35f01af1682bef0200b159f224fd4eb40d0e4056fc1e39d0"
  end

  depends_on "python@3.12"

  on_linux do
    depends_on "net-tools"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Although spoof-mac can run without root, you must be root to change the MAC.

      The launchdaemon is set to randomize en0.
      You can find the interfaces available by running:
          "spoof-mac list"

      If you wish to change interface randomized at startup change the plist line:
          <string>en0</string>
      to e.g.:
          <string>en1</string>
    EOS
  end

  service do
    run [opt_bin/"spoof-mac", "randomize", "en0"]
    require_root true
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    system "#{bin}/spoof-mac", "list", "--wifi"
  end
end
