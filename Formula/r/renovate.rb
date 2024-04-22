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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "186a62893f9bca964babf61453689488b217e396f187cbd76a38f9ab9b464de0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03388b97ee37ae5a1866348f988f952ddf1821978796625b1c6dc17f36424904"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "149a8561efd5292525c5dda2765e3c367429481ca0e3c7f41c907e638daa5deb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3ee0bbc074f032b632a908bd27f60cc52a3457ac60aff80f2869613f0f46117"
    sha256 cellar: :any_skip_relocation, ventura:        "617da3b252478a3d9d66bd8b24cb339b4aa80a9e27878a8949731de97038ee86"
    sha256 cellar: :any_skip_relocation, monterey:       "7c5f8e47d25373e30e31a7fb317402ec018a71ba763567bc0ac2a1292cedff84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30b8a2cae941ce25e344b6c65bb3414124e75880d3588988495b263d43a587b2"
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
