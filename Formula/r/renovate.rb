require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.357.0.tgz"
  sha256 "bc051cebd9e6868ee5c23a3882c1aa5c6978d12f392d118463b4086823505364"
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
    sha256                               arm64_sonoma:   "7260f0e450d692d51d3a5b2dfe2c718770476844b47457b6d0a434470370f3ac"
    sha256                               arm64_ventura:  "7bde112886530e0ff440ff679742357c77c278086a62cd8b825f888891dcb549"
    sha256                               arm64_monterey: "87e890604bbbdcf291f0102d7033c788c2c47bb3ef4da79d0161418d9004e3fe"
    sha256                               sonoma:         "871e972978dde19b53c350325ff428561bd3d1ae00a99a2092bf9eb6cf1f78b8"
    sha256                               ventura:        "221303ab2c90b999e3242b2b787033a9695de7e044a8fb9d434cf5985f3d14cd"
    sha256                               monterey:       "8a59919d2ec4aa7a21bcca154d4fc2aab50dc7156e15945e4ceed6f9f7058648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9da6d1d23e77be238d911d859b0508151de255987fed0795037dad8aa3870bc8"
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
