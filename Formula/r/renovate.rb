require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.285.0.tgz"
  sha256 "0c9d2c29fb816003a13ee673a10ed9ff900300c00769b319dfad8c2befbdb6f6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42cc6014e09ff24d29479f35908fdc3894fe5380bf9495ef66b9d25862f8012b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f808fa4cc1f4840eb80fa67ff3b406de8b732372f0d30224db6983cbc98c6df7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31eb09ae6309168ae3e907d2ae6196f4a3b7f22b9d8748b32a4dd97c19b5412d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3042cb07b42d10a9f372b187b4238527f5811d73c262a20649140194578c62c"
    sha256 cellar: :any_skip_relocation, ventura:        "b541420948ef0dd58f3f3f557fc10d0993f06801a14f81e26db411aacd51d3c0"
    sha256 cellar: :any_skip_relocation, monterey:       "42d9ca6a0bb2d8bc534f91a22c06dfff14efab19e46d9d86b4c4712ce670f42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6871c8d93a5c981709949143280ecd078f546a204314a5a97310d836fd82861b"
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
