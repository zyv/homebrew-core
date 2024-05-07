require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.348.0.tgz"
  sha256 "9dd97864d521a4fcf1b6823638511a3477f6a66f9d611eab4c314701f3a99d7b"
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
    sha256                               arm64_sonoma:   "b332d71652b605ea5fc4097ec1f7de753b033745cb2556a3c229f8d77ac1ebea"
    sha256                               arm64_ventura:  "33d13676cef9fcfc9390f41b6aab45aeec7589dbfb5d6c569fa08bd6984ec487"
    sha256                               arm64_monterey: "0057d3e456f81e57988805b17368ee9bb546035582cf80835054d121a069156a"
    sha256                               sonoma:         "19e95ec70a2848f0610a8f00bd86d1bdb9e2be594749027b190f687a97a0e5ea"
    sha256                               ventura:        "c5b4b621788b67003006ddbdc9babd278ae2fea6f1f457f479b2af63c8ddbc7f"
    sha256                               monterey:       "8228e8af44647633ab436bc663a0b80a7e38706d13ec05419714d6c41e8946a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab1e4803573a62224f67a4a26864e2d3b0a0eaf8bd2dbfc7c6fc17edc98dfce"
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
