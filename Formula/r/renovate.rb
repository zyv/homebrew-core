require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.322.0.tgz"
  sha256 "6eecf17b8bf911f6b1c54d31fdf0b276c21fe0517ec37db8e94d6155aac73b03"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "297204453f37b12f6dbe115223b312321472cca6d8d82fa27d9972907e20d5c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f9149d97ba9daf94f073c881a04291255524fd4a5dd4c4e0bfed8a13cd8631a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "289136f246bf6c31aa1106720f5c2222eef8decb08dfcb9f0392cbc065c9274f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8e9e189afd9335abbfe6ef17b3492a0c7c9b25eb7cf766fcb08a35a4246b89f"
    sha256 cellar: :any_skip_relocation, ventura:        "48aba6d67492a671fbdc08714f33cae929b6d681090b7893ef3114ac7f1a0018"
    sha256 cellar: :any_skip_relocation, monterey:       "3ea8b5d5a09fa11ba412323b915ed77524cf97af643cb0eb0182df572e622f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa538f9600c36bb7a1214b35a432e8fc4156f3cb8f9e9ebb17a36341b93b158"
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
