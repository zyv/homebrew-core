require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.288.0.tgz"
  sha256 "476bd0fd83faeb53ed68eb699d186231979425d3fc465995773ff9abcb1cec64"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35135b55f4b4f20a6cebda8af8b653e487c81f1a5ab67c5c0259908f7c5b5786"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31db1f506ae4aa05351b6555018d2e8e9727efad30d6103274c974f5bb525261"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b22d4646063f7abf48d45b18dc4c0cad1fe8ba2a80237903615c19c508a28a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d492f0692fb27ea98e9bd72884a8ad1c289b9ebb182ced799e25a5def328e3c7"
    sha256 cellar: :any_skip_relocation, ventura:        "2e41ef030c1e2999eb56d13c53e3e3b9621cdc0c4e06ab133273ead5bb415d34"
    sha256 cellar: :any_skip_relocation, monterey:       "f8eeb602eb955cd91adebdfa44d6073aa0df01a6677409d7b887d01dce702fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15b948d5d714b3eddd595d283726bf809e263f2681297d1bbc1a320eb16e4b85"
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
