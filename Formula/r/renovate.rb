require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.374.0.tgz"
  sha256 "dcd9d196674f71e33fe480400f5228ed366532e879ef72119e55f2922cdd86be"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17cb93177bd7c8362747172c377cf0c6a296ec73784412d7971a7cf9aff5963d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7342fce303f99d531d1277bd215b32062a0bc2e4e4a4007aa791fcf0dd91b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2998ad0c20009e8fe4dd39346f503ead88b6ced5764f90306b90dec873641161"
    sha256                               sonoma:         "d7b446af1c5aae5a47a3ce1efdb23bdfcd08414b480362cda86f3a17d4cd53f4"
    sha256                               ventura:        "ab525e8eb1af07e34560cce1e97be930cfbc7aed3cb23a26930841fc51bb3c2a"
    sha256                               monterey:       "8e667ee43e6d36861ecc2434dd4f2538afb4d093099112c700d992a604f86463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ad933073b4f6bbe93ec62aa3b225ce6d8807696c32a17d1b096eb9fa8b52e40"
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
