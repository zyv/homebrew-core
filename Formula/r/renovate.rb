require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.356.0.tgz"
  sha256 "3a22954cc5c64cc027dff193683be27f3d5411c9436fea00cbbca366524473a7"
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
    sha256                               arm64_sonoma:   "d581625710f2b9e69f63d3a12258866ea47d76d5d21c92845de46cb5d457607e"
    sha256                               arm64_ventura:  "2970128a25c6031dbd0cbfe8b7d9fa47e7cb8f6b967bbb2fbf9dd220d9d84bfd"
    sha256                               arm64_monterey: "e107fd743365f3502be7883d29a9af2e2306ad336a39132d0c9ca68cdae4ff3f"
    sha256                               sonoma:         "5acf1e71e01cc1383a69d84fb042ea0179475d7486ffeb24a6bca7d50f4dd22c"
    sha256                               ventura:        "cf698b2ccc50871a01051ac6161c90262d61c50ebcf7128eca2e040703778f16"
    sha256                               monterey:       "f88e4ecae202f1fd250b0597003139f15c206140ea6e6d970bb25bc6e01d98b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91bf252f33006fbd1325c485a5a0c7aeb37906670f7f65fbc0d020d9ff2a68cb"
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
