require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.314.0.tgz"
  sha256 "ecc74dfff8aaf6ad17e73351adc907c4f26178bf63c613e55a35e2f8eca25738"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67ff583afd8144b3d519e2f0263eff40e1a41dd7c56d869fc6c935edbbb7fc21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fdb8c34268884a78d8acd708e494610312b53cc72455699b067edbe808712be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aad3d3210e2f2c6052e46c121325e2f564492b7fefbfeb61fc60067ed652e3f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ee61f96c7f87e40bd4eae48013206c3a2bb53ab2c21fa6b1fb9e71455ce1573"
    sha256 cellar: :any_skip_relocation, ventura:        "abedd987460857fd87dcab53baba8c1c57d128d74053d45d26c904e457503151"
    sha256 cellar: :any_skip_relocation, monterey:       "135076c96eb74e5e66ac0187a4b7d3e4809ef9b35d02a8de7e8f2ebd17db1413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "956b7bf7ee5899cf9784102fc0107a30507f45184893e2fd42e54b82e9aa4ede"
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
