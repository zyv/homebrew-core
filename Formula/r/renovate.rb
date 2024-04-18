require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.304.0.tgz"
  sha256 "f314134061e1946dbe8411f146557b17c6e077a2f8520f2433e663714a250875"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fc628eccd9afcb63d8a3e3a84c7ee63745fec22500bb7c33a541e0e18ab9d02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c495f89c03f3b4e9f97b63d78acfa11d31bcf0834c9c6ab55f844857ad34b792"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8de07360f931409dafb65d8d385917687234379484071092e0ee09548b234818"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d2398a6382cdd70d1ec896c722e2affa343a3eb8433151d79b3239100db0116"
    sha256 cellar: :any_skip_relocation, ventura:        "b21eb692149214cdcf5c0a5c693f8e537163543e8101e2af974602cae4741fee"
    sha256 cellar: :any_skip_relocation, monterey:       "b4930212ea55794fd1a54d7a5aaec5d6c32335ab18963ed74a87af0fb6b62f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4f45cc80b42f6cef044a052345e3e662a911ac13dbc63f50917d10508977576"
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
