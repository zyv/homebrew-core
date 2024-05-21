require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.368.10.tgz"
  sha256 "7a34659b3f58fd73f4dac91141e79fae5fe941d0668c2c0aa1fe89c03f051002"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa04824571c3e198e8a3501a2e8236eba8f5d914ca0d07b0e88f9a1ccd56fad8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a11d9d17d157e181527f56af53b0917a94987f5b4b92827c0e28bdc118cd4b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d16bfba9154f47f0fdbccde8c2fadaca1e64009e39af821c0c1da6c51c6643d"
    sha256                               sonoma:         "b7370774cdd6d3dcd82c4dbca53ff316ba55652e4544968dda113a4733f24aeb"
    sha256                               ventura:        "c0ff29f7ac459b47c32257105163b3de23d85415b3c4dc8e4c479c86c672dbcb"
    sha256                               monterey:       "1aed4383a59ee6af1b0d776ea4159270e4a5cf9453b5203e334a1872f89858df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5548487bdcc6e14849c0001b14aa9e699ccfb2028282d6deda94b0aed4090dc4"
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
