require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.382.0.tgz"
  sha256 "49799999728f843842b3bc2ab682d0e47aa3bf69413eef3f2d04a80dbe09787e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db388e46019a9fc594c0916b5f8c98f73f86310841a32044277c8601540ab940"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf363e6a8d1a76f0cd8bb46b88466d5808f03d39e59c218ec66f3c09ad7b129b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5a8691c33f3258d7b062191110acd08bc01c436ffba4bd99e30053afa2d153"
    sha256                               sonoma:         "353e316e187aeb35ef0d149d8b590a574a6dc007d203eff9f0f74aba2cda2605"
    sha256                               ventura:        "d9ab99df1636eebdfd5e6a5023071f52892448681c9b6ea0e8977f0d5608f7d8"
    sha256                               monterey:       "9adee54e7ad7973e5907f4a5ed3fc5d06bc8baa955dbcca2759b93ae6774eb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ff42b0c6144aed28060c060472ebd1649f45d58f634d014f5ae580f6510e7bd"
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
