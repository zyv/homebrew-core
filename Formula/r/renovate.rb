require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.376.0.tgz"
  sha256 "cc05af56bf2ada2d5729917377b1b93df29dbb3436bd3d3d21df4d292f0e4e8a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca15a97d14daebb6c0edfba2d30e4167c3b9285b5d17750967d8389a898e7085"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dff9b79647b6a84498fc262366cf98d54a3284f350989d493726c780b9e5135b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a3583f29f9cc3b8d3ea31342013bf7e861fbcddd971a64d078a84757f9d6c54"
    sha256                               sonoma:         "c01cc4b3f6b230a06db660dab0f2f8e0182147c57ffb5882a277e7eee2b9da34"
    sha256                               ventura:        "a77724c524fd5cc336a4bcab5021c4b5c90799c58f5f0f9dfc3e67f56f6edc02"
    sha256                               monterey:       "1e4bb02132f6c3dad88b133e32c1fc4b8edc24b57a2fe76d72bcda3ba6ec2a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01aa30550ff2af55c80d7c9464b0996176421e14bff55d662f2094a20e4023eb"
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
