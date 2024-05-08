require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.350.0.tgz"
  sha256 "e5c2d784addcc2339b6040cfe8b6b434102f294647a2ed0f7f2e258e6002643e"
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
    sha256                               arm64_sonoma:   "38c4ce851cd9e2f2a4930e920d51b9882ba6f63a452308e726ace880252f81c7"
    sha256                               arm64_ventura:  "b7f2af1659b39f2bc1fc3500f0490f75381e9c690e6f93eeaec45a7ebdebac37"
    sha256                               arm64_monterey: "e4b0232e4a34f36888ebcad068c8fb2d517916f5d03698415a2f5c401969960c"
    sha256                               sonoma:         "945ac99982bfe81c3bd779150e9d9b8b2136bc9c8eafc517b10e3f5a29a0e47e"
    sha256                               ventura:        "00c6d43f1c1548c6f6044984442d68342e5677d86bd6c92aa16d84b11daa3fc3"
    sha256                               monterey:       "4ffed648f132d97b4ae567a5986095c6784c21f638a41845b5fea08e49ebf2fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "091f748aff2c2f48c6ef54911b89b4719ee3881f8ab7e52c6196ef7ec683c350"
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
