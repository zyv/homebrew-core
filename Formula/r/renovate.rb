require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.286.0.tgz"
  sha256 "4ad661c6c1bdc15d7e579b7c0779f8d5e6f7f83821d8d1c3502db4deb533febb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed2017aba12de7270b4a5c7e65fe556476ecbee19bfa12df82a5b947cecdd05a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fffeb26af65fa3d5ee7f3fca956913ba0ce188ba509a4ee9df6a3ca0741a9c84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9a076479d0b3d722cad551ac19c9d142bfaea81b4f392e5d75e0c45f734bfc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f132cf18515f88f8faf6daf417db8aa056aeef18c3fea2f694958d5854e1797c"
    sha256 cellar: :any_skip_relocation, ventura:        "8f07e94c45fef4ae6f1015c9928e9d0bfbe1c5a03ef89e0bdd9e9d55a457e92d"
    sha256 cellar: :any_skip_relocation, monterey:       "239516a3b39c9262d976121772c011beacd4918916841f9ef4b72654048271aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29f74bd2f2102afa736d7c15132092d508efdb33a474c89e09cbd05253afcf37"
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
