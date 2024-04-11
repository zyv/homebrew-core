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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2493e85e4eac98e12df0469deed5a7e0c11c78570764e117f50a0ac2b1f0d3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbcc77c75768ae6eb91bef8c40df95b0356923ecb2557b9429eee63df3799eb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "156117910230b5ba0c032c699088b06020b00c5cda3771e276ea8e915a103fe5"
    sha256 cellar: :any_skip_relocation, sonoma:         "778ad5566d01840f15f17c272428fcacedbb99afc308f9641055d4d923179d74"
    sha256 cellar: :any_skip_relocation, ventura:        "7b4aa362500e580005ecafdb095b274497b77566638601fb250da4f4c8c46e4d"
    sha256 cellar: :any_skip_relocation, monterey:       "ff934f5c0aba6313783c1a3b8ee0666cfc94780d3ba018bf477e131adc7dab1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70ebf8882c82d3072e2fa9f9ae5f7971aa72a8577e2b43d5af650197de2fd5b0"
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
