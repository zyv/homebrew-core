require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.311.0.tgz"
  sha256 "869edcda01bfb80f865c4aef4a82749c5f90a0d41efe96a18198f2e3bf9d44dc"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fca1813ded49e02e728d337ee073d3ad0aa193e4b50e30ff82381e611397ed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6528e5c1c6482e72d975fb5c905de86b1f7b66aacf03a55025a3c79395084db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1edeabfe555c544c64563342a103853425d1c52e3850a67430f6b00891266a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d5e0c051b66beb304b889569427c50f5f1f52753d99137e1dc1680fc733931b"
    sha256 cellar: :any_skip_relocation, ventura:        "2775dc126cf9f1907d7682fb252b6329dce88a6e0f6088264db73fac1c91d74f"
    sha256 cellar: :any_skip_relocation, monterey:       "64d71bd636bca9e904d233bd97c0df8c278d669847bf302e09b8b62c0cfd94fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a1d850a0b9b6e8021d0ccca4c3b5eab9d8cf60aa2713829fd254cf66b99da8"
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
