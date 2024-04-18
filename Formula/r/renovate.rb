require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.305.0.tgz"
  sha256 "f07ceae4b35bce8d42e2f2a8f651136392c345a199aed33461092b06acc58ad1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcb1512b6964609e93926b5dd4029d7f7da6551fc98d08217dbfacf6dadfca08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "077a29179df63323744d504a52aea370d6e518da62fb94f9e6ec03427e44347a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "081c30d0c067b95443d1bbdd94d8308a5aa6d9470406e6cf4da511051ab7fda9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0083c5c789f12e967d0398492f4472558ee993cfdab0b3fe1118eb8292b7fb9d"
    sha256 cellar: :any_skip_relocation, ventura:        "73e45ffe054f45f3e6f892d3e901689a1f7cbb083c48a8e2d80aae4d59800088"
    sha256 cellar: :any_skip_relocation, monterey:       "029e78b67af2f73288892d520930e8f64a1ed4b16e569978906894f4b9af980f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "961dd327e8a01f46ea71b80973dcd2eb2499cf1255eb7de1cad819d9dffa6ed9"
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
