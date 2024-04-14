require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.295.0.tgz"
  sha256 "a588606799c9086067e3f6eb67249f1b21c34311995b58de02d9da191ce56861"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0d93212cd19b2911a57add13d3bf87ff6df79bb19750adbc0f510a0f039c00b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "540b3e95bc93f366aea3da658740128e9ddbb337cedd2c4759319289311f404a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80f5a9d24e726fe1d76c0e9c456ae222344a27457031120c78b4f0559869711d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe1d697275d4eb6fbd953cb159f380b3109b023ba8cd9ef3fbad39ca4bf86f97"
    sha256 cellar: :any_skip_relocation, ventura:        "d03ecf1039411c9cbce2f5a6fdfb6b88cfba8627b14b4fc23745ddd1f16f5565"
    sha256 cellar: :any_skip_relocation, monterey:       "4c8a566db676a171b7d88511d0e0786cfc77835e41f2c61fd0807b41d307fed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92fa048990298fa26bdf50afa9f1ad0786b4f3889d27570a6bc8b15e682ac4ca"
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
