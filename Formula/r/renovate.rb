require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.347.0.tgz"
  sha256 "0bdb2acfc23ca4dfafe0d3bfd5d7f48804a74f3861edb7ed2210c362f9d2087b"
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
    sha256                               arm64_sonoma:   "bf6033b2024cf918ea9e50b1c62856160c48a5c221a851bdea21555aa9707c38"
    sha256                               arm64_ventura:  "88c29935e7699c115f521426090601fa9c9040d05d18932e9c20b85e52f84687"
    sha256                               arm64_monterey: "52a9f5b3593ea6ec22253d5eacccb856591032f0cfaa3f96e60a4317906cbfa7"
    sha256                               sonoma:         "d62550636e42e5b889111e6994695f8ca555e37a4920dc993ea99e70eb3b6404"
    sha256                               ventura:        "adcf19866043c75c155cffc6950365e6c48798d3ef640a0502211c37323a9d9d"
    sha256                               monterey:       "e3dfc94680e16c643f91a0b8f669a189bfb911b4f59ebbb0fe6f7ac22f5d3fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51414e215248a23a8d9fbb514943631bcd7bc8110aa976cb8da413450c92408e"
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
