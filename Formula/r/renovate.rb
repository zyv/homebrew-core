require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.363.0.tgz"
  sha256 "7a7a315a86062ee79eb74876f0ab99ea633ffd8a19f7f166d8c78c507c52270f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db09e0bb1645f5a3a6ad346a983a7a542c772a18f45b209994a0ac867c538695"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cde70b3ca8c42d611688696345291cf91967a810a028ab56160f5a44088455da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc6b848f88549ddf2716a8ea90fd594bb4745f6b056781a63370857e6edd81ce"
    sha256                               sonoma:         "a81c485adc21a2099e5df76e5ef93b6cf0af68ba83b2eddf41e7d3699acfd25b"
    sha256                               ventura:        "6f07876e5641e26abca7583cfb491022131c6df7edd604a1244765e809e8ee2a"
    sha256                               monterey:       "81e2efe8a5688cdd9b70deb1a48134dbe0d93b0a4d6b5d1e14a95de2cb2f34d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bec8685e5df6fd65aa1137fb6ed3299b180786c5ece5bbb2b90d0a582d41ffb"
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
