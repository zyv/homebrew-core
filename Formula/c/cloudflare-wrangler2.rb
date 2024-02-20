require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.28.4.tgz"
  sha256 "379c769ad98d9d06ad91ab1e0c7818d2d81c7d62fc6494d0a0a094d2002a4ada"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e670119f51e795ee9258570adf3b13d5aa6599ba9535e5a5df383db26c64847f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e670119f51e795ee9258570adf3b13d5aa6599ba9535e5a5df383db26c64847f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e670119f51e795ee9258570adf3b13d5aa6599ba9535e5a5df383db26c64847f"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec59359fa664929cfef11d5814a26a36ac22f2e6350c802a7cbab43bfa5f203"
    sha256 cellar: :any_skip_relocation, ventura:        "dec59359fa664929cfef11d5814a26a36ac22f2e6350c802a7cbab43bfa5f203"
    sha256 cellar: :any_skip_relocation, monterey:       "dec59359fa664929cfef11d5814a26a36ac22f2e6350c802a7cbab43bfa5f203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ef17f845ecd104de123f27838ec16683427d1ecf553c469b1742e4fb06f7249"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/wrangler/node_modules/fsevents/fsevents.node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
