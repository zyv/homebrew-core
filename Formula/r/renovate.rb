require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.342.0.tgz"
  sha256 "ab216f0d45af69522134252936376857f8da82333c4b94a01bcfd3b4ff0b23ba"
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
    sha256                               arm64_sonoma:   "f1e64052783c232daf4566de8ee92f87bf1abb933d137fc75b462341dabdb79b"
    sha256                               arm64_ventura:  "b0f1497c0a5f5b4a61ed8b9246dc85c504c204c4d2284b24ab20195748302bb1"
    sha256                               arm64_monterey: "fca04686ae414aaef9680f044235a2c3bf0ccd4c7fd8748350b626682b416a91"
    sha256                               sonoma:         "c7d0a87e9fefb641dae0defd96527cb2a8ae394e8ae96ddbaae0802e840337b6"
    sha256                               ventura:        "fc7430bcdb723137423b8197a773e7ca213fb5ff1ec08116d4de4ae4d8fc6122"
    sha256                               monterey:       "e9bc12585feffc41401012c7f47898262d51b6cffc65dc5714d3dd32af43c3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a7375ef1999714cd3eb91bd62016e8c8a5dfea51b3c7a8ea0e79d524eca580"
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
