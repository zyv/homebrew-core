require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.341.0.tgz"
  sha256 "0ce7d41bce38118f6bed58c7e79b81f294e7d15f8bbbf4b783023fdb1549fb3a"
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
    sha256                               arm64_sonoma:   "e899c3c52d9aeaa36b6fbc3af33fdd059d4fe72e8171829538acc77578aaee7b"
    sha256                               arm64_ventura:  "b57a568b23852bb32e9dfe0751cf03a0ef969274d77e2b404c022d752786f241"
    sha256                               arm64_monterey: "537c41cad08a4352ce3d7770e139cf212511ec98d23ab6a708f39b2c31ce8ee1"
    sha256                               sonoma:         "f6112e9a1510177334daa0968ca3e11ec64302a2a9885b7a5bdad7e98ecdc21a"
    sha256                               ventura:        "11af4a31a0da6f7bde0a95233ae53d8d635f4b3072aa716eb6d8ba76279ff6f9"
    sha256                               monterey:       "2257cd0d274180bfdf27cb45c48e84de099df200dcff6119e9851b534f16e3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "603202bd5fce6922d0aaf3202b2247f47f9e61a92b56c667574f9b1933b8a731"
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
