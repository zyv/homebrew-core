require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.308.0.tgz"
  sha256 "3f2d629bf59c6656530879d25f29bed2ca3ab6a1708a62e3e3e0ac1866285fdb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb58da5b02a79dfa14cbe29ea0392fbcfd254b001b8dee11feacb57c9ced6ee6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25463b5349db666dfbbcb02b64711fd0118750aeae73d4b463117c5d1d4256fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d48ab2d06d377b1727a30909593c245bf30eeb36735006048191a50d94a9ce0"
    sha256 cellar: :any_skip_relocation, sonoma:         "421585350179b9c6a88b3076dceb3869174feb5c01a9ce4f72c076650be05523"
    sha256 cellar: :any_skip_relocation, ventura:        "83beb4f716b7858a0b0797c01a0bc7c3255ef30235b30c80159ae83903ba8d1d"
    sha256 cellar: :any_skip_relocation, monterey:       "bf5342b3224de81c799709b97abde69988eec0f8c868f58409b14101f3d38984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67aed7ca911683020af012e7306f1e6566e29b926545eb8d93f28d22e39177ad"
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
