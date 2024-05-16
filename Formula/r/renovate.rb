require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.368.0.tgz"
  sha256 "d93f9fbc9fe0f22b0ae58b3c75728c1f3cba9a3c906f3d83d42cc51f6adb2f7c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "922b571ab82059992f7abc27dcdde7483e14857ada71444854406e32f7b9547c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "503c71694f152d0546ecbc31460691fdfca0fe37caa60f0057e1cc1b6a5d30a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d045cda8b0caaaf454f2d898a141ebbf38ed27d8d6dd36ccc255e48277e0a86d"
    sha256                               sonoma:         "3b6ee9bafed815d62746fc5f88ff94e05870b0fcc61ef3af1acc86e6121e7db4"
    sha256                               ventura:        "3eed0d9271da807143ec96bf8a6394749b7e31ef449f331fc2376383eaf57625"
    sha256                               monterey:       "5ab78f37769c72b9c4b5ea028674bebd941df58536179ba227b44310c073d420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "232162a4aae36cde38e9bd65ebe070e95652ce9ffc0cd58b70eb844100091454"
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
