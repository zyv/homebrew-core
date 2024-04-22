require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.317.0.tgz"
  sha256 "e775e02d0fe08d733e0f3ba1dde23c5fff9a87ff438bbba9935a62f2a92303a1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13cea686ea68e8d80000b6a31a1745a8b8a54b20f69789042f883d1f1608ffdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00093cf25b2d371d6909834b5ae0137291d7a5ee5a85a66de79587265f49ffe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ef8339caa36703be541704084ebb5222913db6e29e5031387d337425252f1a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "21974bd5ee3aeb7c8b6b96cbf25359df50fcb52d62f7ff7dbd677c0b87114b93"
    sha256 cellar: :any_skip_relocation, ventura:        "095c3809c2a98d08bf70cf15e47c8d379c648f33e7c686fd62071eeafcac4624"
    sha256 cellar: :any_skip_relocation, monterey:       "ea2c3f4fd93478e418c02cc4f4b83aab293bbf1784dacbefd43132ed5e4e399d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d1fade5feae07110abe79d485d6146eae69804f9a9b712d5327d01d655375cf"
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
