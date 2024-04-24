require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.320.0.tgz"
  sha256 "3a559bcc497839e25baa188cfbc8f726bbba068c8d27e4e9aa58f2e31ff98959"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "895d74e5082f4062017d3b5247164b5c18ab71949e14c927116d63950fb00cb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0c6ac14a34d76dceb01a536b74e340a884c69011bdee2b441454df1afa8f70d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99c5a54cd5f23ed9b81b7614cb415d2f7af455a14d2e329330520a3de2d4ca35"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad522d392e4e8cf4d8755e4dd481c786a5ebfc1a83dbaed56ef31aca386eac49"
    sha256 cellar: :any_skip_relocation, ventura:        "b89364e566be968401583882c3722183f20ea622e90e0275e983fc063d829d5e"
    sha256 cellar: :any_skip_relocation, monterey:       "ec4730aba375b38c5f719e1435ba06708f147b3ba93282b3f2da2f0af5f65191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6851de8332c6aabfc361c1a482be96258b7700301eca247802f4952c5674d4"
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
