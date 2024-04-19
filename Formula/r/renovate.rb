require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.309.0.tgz"
  sha256 "4a09caf402877239e04c4c87fd05e9998cad45de3370edbca42d311d627692dc"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e733e44febe39cb1c1f55e9706c92b932cbf1e0a0c18c4c7a3e0ce3ba4141282"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5888a44c179585eb38b7109f68f1c87719c60a28fb0a947677fee80ff39ceee6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f494899d832ca29a93e3ee21aafe54e73908b0170d4f1ea923a0d464f44a8998"
    sha256 cellar: :any_skip_relocation, sonoma:         "f05de2f40b74d3eab863b092407b20baa10e2b1226bc8660accdee17992f1b6d"
    sha256 cellar: :any_skip_relocation, ventura:        "18a61272f56b7ddbc6b0b07ac972177efd411890c3d2131fb55c16e47b86a76b"
    sha256 cellar: :any_skip_relocation, monterey:       "6b75f83d9523820b9a134d0ce96bad8ed168adac58dfaef45eb00fd4a4e21dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fedd2dff14d102d9d1c9d5993e238bb209aff401d730d2b22587bcc84e144431"
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
