require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.221.0.tgz"
  sha256 "f7d546061f48c12ee0c4cc0d344f42efdfad55ec46b75adc8e2a3260a46a1795"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2f90fa4ff9394016925a8636ac5e6737bb42543c2b9b97e7c20754392d70e30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23e56b435b87dadf977b05b630326dd97565d0c5aadf6c282eb585c6dd0f4b87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a71bdf83ce75e50cd73ca66b4bca1b6cc6ec6b068a58f6f18f486fcf3265dfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "33d6ad2d47b3139aef91615c035ef947072a2503067dc2c402f58e7a9aec008e"
    sha256 cellar: :any_skip_relocation, ventura:        "9288765e2359085bcc121ce86f2ac522aa974812e3759153e578c18668f46c77"
    sha256 cellar: :any_skip_relocation, monterey:       "15b05ffcf8f3453b700c53d783c0d77cc870145dfd6c6dac5f04a020abe1baf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfaa769beaf09895bc4b0dd9f1f08777643071ef4ac9df7b5298adf76a87179c"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
