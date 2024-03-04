require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.226.0.tgz"
  sha256 "88f1e08e16e291f5474d637920b55a39763c5583614c45276a77d81536ce1a79"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe01c8a585a898afb3edc84e20c2ac96495a74aa7450aef3c975976bc573bfb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3026f765aacb3356c2ba957a3be797fbc8a4dba1f5e10f4a335ffcc6b4836f4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c83d7a281284747abea29acb3c32d910d6b80b19c9326cffd2019f42e61ac05"
    sha256 cellar: :any_skip_relocation, sonoma:         "09dbb78fbc14b796961be68a12bb032ae5eba60d2b57765319f164b16dbbd3eb"
    sha256 cellar: :any_skip_relocation, ventura:        "1d6516cf9aaafcfb4a04dea7752b61be8fa27b0b210a7935e25cdb4e88c09ee8"
    sha256 cellar: :any_skip_relocation, monterey:       "e520a82fc198a71a0d46a9f3a202983af73b74e83ca972d318873d1d725c2c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a890d5b7aedeafd0125d61beaba5124c693eac2daf7557e6fe73164c4e4b42bd"
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
