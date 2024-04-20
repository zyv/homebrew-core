require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.313.0.tgz"
  sha256 "b4eddbb9ee0ed5cd66cfe3b5d409d64d2f5df62ad28cd858f34542770eddee4b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "155745bda49bc70f6bbbf99a61d9f945d6acfa17576ef8600863bfb49da5f011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fa2e8c2028a702609157be3b0ccf427ed410d7d04bac4b12717fc34970a5bc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8a7f8977b61b60b07201a0158e43090d9968ca2191a187d27bf4cffa6796f19"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c43683d2570ab70d1fd641b39b1b9ec17eb89db39322022b5ce837bcb4a9133"
    sha256 cellar: :any_skip_relocation, ventura:        "15e16a2da2b424e9edc2430846c0074cb67ae9a30004f1c6912d6f9703eda053"
    sha256 cellar: :any_skip_relocation, monterey:       "3f1980bc311cec3c2c2e0b47060ae6a87aca0494bbc42bdcc77b49c69ca8cdc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40c60c975e90c809016d5cc45ad12c2561ea3cfe2e1e618d4beb4166aaed44f9"
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
