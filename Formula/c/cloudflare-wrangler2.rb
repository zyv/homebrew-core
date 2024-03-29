require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.41.0.tgz"
  sha256 "22cb8dbbf806cd7e49091869e6742f0eeade8013c0a8fa2be6664099daea2e7f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a008a4015a2e4e88162b978dfd6baf61494de579d4085c21d8c9a6df5844aaa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a008a4015a2e4e88162b978dfd6baf61494de579d4085c21d8c9a6df5844aaa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a008a4015a2e4e88162b978dfd6baf61494de579d4085c21d8c9a6df5844aaa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0fc8fe96d074288742c0b41bf1e38d0e45b0d427cbcd01c263312818d542ee9"
    sha256 cellar: :any_skip_relocation, ventura:        "c0fc8fe96d074288742c0b41bf1e38d0e45b0d427cbcd01c263312818d542ee9"
    sha256 cellar: :any_skip_relocation, monterey:       "c0fc8fe96d074288742c0b41bf1e38d0e45b0d427cbcd01c263312818d542ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1188ca6d5776a901ac03a1830a1ecb7868247bc8834f03a638698cb21c72658d"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
