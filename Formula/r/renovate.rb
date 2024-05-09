require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.352.0.tgz"
  sha256 "74403d431929a68976237c57e3d558b020d9d4d4837159ef5fb71c1ad8d58f79"
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
    sha256                               arm64_sonoma:   "72a5d5ddb2d3d07bfc4aaa94cf9084f7e3708911c52489763c3d060ef6f0b7d9"
    sha256                               arm64_ventura:  "8b062c8db1647a63458185a6de8373dc96c0dfdfb146cf7e4edc5ffa396aec23"
    sha256                               arm64_monterey: "939f370136875d1555917c69725fdc5ac488f6d067f4a1df3b8236faefc6a639"
    sha256                               sonoma:         "7afee52e93f98ce59eb802a8a7059fcde96965f97b3bc0b6cf4595a14e18be40"
    sha256                               ventura:        "555f52d040350fda632dcae1501e17ab974b56933cc31d3dd06327650954bca6"
    sha256                               monterey:       "549122cd21a8bb331e5bb6adb53306591b34aea10901e524286d177f5d481875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6ae9943cde35d42debfe7597439e57c4dce80fc1921a8055e87d221b9c1216f"
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
