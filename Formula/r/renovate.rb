require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.294.0.tgz"
  sha256 "a5118c58bc1d45469f958afe14a1e2bc395e947e102a01960c5254ff2fe74be7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dd3236a1e5329a65ea938503e0a0d5e0d08e9bea49430e3304ba95b7e323cd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1dce27b9b62980dfd5ddfe3c116b781f854aa17434e951264c11ffe44357089"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d283d494736813559f7a6e7eb6d5246af088f2674bb82fa4e7695e81f96248f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e9c4f3905385bceb6e4551e291437c40c707412293a5398496485bd012f0234"
    sha256 cellar: :any_skip_relocation, ventura:        "b0472bea508a9ba41645a7c529b06738c80f0b4a37f84f42d8cb992512b82fb3"
    sha256 cellar: :any_skip_relocation, monterey:       "60920e0b5a69f863de95471cd2a01311443b2ff57e8d6b432cccc687334a21c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ef40ebcc09043ff273a62718d7c71de6ca6a0cab969d306580d0b770f51278e"
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
