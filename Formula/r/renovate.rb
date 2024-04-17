require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.303.0.tgz"
  sha256 "89b3cafa0c103402633629abfbf78da3fd268cf59ac32d25ac514a8fd01bdb19"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3de06ed68ac4c9b775350f57f0eb84e59b3ae5c56cba5dc4a7cbb33baaef017"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49332c45f21c6e130852b036bcec57d1d9295bd179d9393a897fc01421cc2724"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dcac41586ca78c13f7aa1e47d34ccff54a786c06de0c4529fce1484d82b121c"
    sha256 cellar: :any_skip_relocation, sonoma:         "96a7b4f3ac434f25d0152b1d55b2249957136bbe5e3526fb4cbfb02c4e2e7d72"
    sha256 cellar: :any_skip_relocation, ventura:        "feade1e20b4b130d67d40b567575bfcdf627fda2b29897aef8638682c00df4ba"
    sha256 cellar: :any_skip_relocation, monterey:       "e7fcd793ad5d0fda20cba253bbd989d7d780c55b3cce4b6030a1bf021dcb0215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde239da049d2a741f9c3d6c84b93cbc73c3780edfc988ff2b95827e2af33fd7"
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
