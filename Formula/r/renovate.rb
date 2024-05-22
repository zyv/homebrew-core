require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.371.0.tgz"
  sha256 "977859331c6b0c305b159e10ac8383d28af54e998aeaa15c14951190518269b1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dda82aabb184c1407e1b95231971ee7f5a535092e6e455546a969f31afca36d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f6020bb5d07a2f49d1fd25c24f144bcfba392abdcf263b77bede51a1dab81cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25efa4175af7cff6c29c49edcc2a77378b6c9d9841941adff075146f32b18fb5"
    sha256                               sonoma:         "9ac83cd52025edc8011740eac539c58c21261399e06016b0e9d4ccfb8ba7a02a"
    sha256                               ventura:        "2cfe63b1eae8849e46e6dac8ed616d137791caba1ca3871218d3ab38f13f55ff"
    sha256                               monterey:       "5bdd7479ee55c04a0f34b991400dffa0eb4c4bcb330564d19cd993537e0ccbf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401352a1649d3e1b1c783113841fd43c20604398d148720f16fcf57bb4f1e8d2"
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
