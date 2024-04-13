require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.292.0.tgz"
  sha256 "4cdea3a803ffe53dff47e2f547c63657e777912c337e057bc90a79f9c1e4fc1c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e3f8de01966af321e9c62c406434837835d749f9870a765cac4b2afd2a65396"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c9776606ee3a8b2012e5a7624fcdf052947152f9b5812288db0cc543b420c3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9719f30b6231f880d168d3b60d2a1776fcbb725e28593da64df851ad121b3963"
    sha256 cellar: :any_skip_relocation, sonoma:         "c86c98b024b6e5f9c7a94cf15721acdf06c124cea7a6c0a07e19ecfdc47ff69b"
    sha256 cellar: :any_skip_relocation, ventura:        "8e69b6cb5d48e2212868c8324239f190fd31acfeba4c24b24410b22aff41978c"
    sha256 cellar: :any_skip_relocation, monterey:       "bb1e6896a9824e0a357a46a8085ea1cb828c214e83433ae04434de67616a9523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dac6d42960cea97a5a57aa89e79893b429fc65cb590b89402fc6585c7b4884e7"
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
