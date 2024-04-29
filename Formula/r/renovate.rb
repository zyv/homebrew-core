require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.328.0.tgz"
  sha256 "c9a8e1cb4ee37f2a447f1b46ef8d0cef7ac128381d85855ef407b24033b63e6e"
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
    sha256                               arm64_sonoma:   "a1555be4e95029912539de33342d4f9b3e1b73d86b6d08e8c250f2e1215b3d87"
    sha256                               arm64_ventura:  "e669668784984b7f37f1431125b1b7cf23edcf1a7b7f4ae9dd95ee0d6841c65b"
    sha256                               arm64_monterey: "1ed7b472227dc6f75f3618c68275a890ac00c52c401583d264691357310b1d22"
    sha256                               sonoma:         "652811fbba92ad62a08cdc377537928f522b6b37b9d7bf33489b38fd93633c03"
    sha256                               ventura:        "7f914542f9c264f0059d32204276909e0b6d284c48e71cb047742f5247b36272"
    sha256                               monterey:       "77f3aa925bd9b106c851d0a2bfe7e027a50e76ed76c7d90dad577649c5050bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e1825f7a8ebfbf60b94d132afc85f0af68bbe318f10f69e7f5ba38cd3b1dd5d"
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
