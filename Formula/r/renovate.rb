require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.345.0.tgz"
  sha256 "73ccc34ca20c5ae5006288b0006ecbd8a6518b0c5364c7b749d0420b30ff17cd"
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
    sha256                               arm64_sonoma:   "2a030e0dde314482b6b534475e08305f850bcf6d7830da8a6550a180a224acd6"
    sha256                               arm64_ventura:  "67f5170ff83e1bffa62630192b43eaa1616c3a3d3286bed86393f341baf05bc5"
    sha256                               arm64_monterey: "50ffc5f432b5e9494f98017b3c32ca99e6a52bea89a318d6f67bfc7eb8151412"
    sha256                               sonoma:         "4206902e7f23ae8d306f21759d2619d5c5910aafd250e2bf5044fa1642925722"
    sha256                               ventura:        "d8fe26a181994a54955fa9a836bb0d8935d9d745974c325a3d2d9616bbf41075"
    sha256                               monterey:       "4b256e90b4e1d1b9051a1e664b3968656faf9cbbd9088b9bb3c1b3741dcadd4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c048a44e8ac9041fa7b5c9b5c5a95dadbf7d80901a3b8ba2050bc78508fce602"
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
