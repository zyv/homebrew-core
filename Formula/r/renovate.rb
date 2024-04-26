require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.325.0.tgz"
  sha256 "19c34267029943a93d4f6394d67ec10c965124587b03da17407c323a12235a62"
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
    sha256                               arm64_sonoma:   "ab767269380c7c3de840a132b6f56b06f8f67b2335808a4cf946aaacf7e9fd5e"
    sha256                               arm64_ventura:  "ee9b6940eceb9e01e5a7419bfbfc3e25da635630d50619c10aba92b3294d967d"
    sha256                               arm64_monterey: "8476d7ffa8560c96f614eaf2710be2b23ea88b88adaf9bb4fbd9041238f8a5d6"
    sha256                               sonoma:         "e2c5cde3d8a16bb72a5b05341772a2a1eff03c5e0261d24b09d13a8060c128f0"
    sha256                               ventura:        "6ad356078f734abec6b3e6a2df870c9e951f3a783a1809b44805df468980a1e6"
    sha256                               monterey:       "00a984d4a46b90d562588a6435eb4254e71d87a82f4cc0482ff7f36c86d94925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2d0441c8927e0f9ea81f0be60c678373a8e46a73294d0d11c3210b29c94cd5c"
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
