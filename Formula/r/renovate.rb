require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.370.0.tgz"
  sha256 "2741d9b9648a690a300236f65835b88dac068b9a66ee376bc5eacd6d7d0a016a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2f9ed484e49b85c098387127cfeb5abea7deef2b3847523951752508678fe98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a0de3a331a8ef8b19b5457dcc3cfd0f623a2bdcf37dbc8ba78efa4977b6ef62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "876b6c6ed4875d4f5c47cf2ec74fb320eedc1b70925932d601e2ce251fc68928"
    sha256                               sonoma:         "9c09c5a6999666246f52e7e9cd97642b7bbeb3d7dba0a9a7b2523dd97ef2de00"
    sha256                               ventura:        "890aaf55a10de63eefe0df42c0e7931ae13f0f1dc885479e072afc6da91467d1"
    sha256                               monterey:       "f94db3c36259c10ca7b28786fe8c66412d78580d1ba3f60e42bf88ab69d9d0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3010c14aa9c5f40607a59bc63204ba3498b8aa0b18c92d0fb4cc6fecadbee62"
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
