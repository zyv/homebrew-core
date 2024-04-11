require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.50.0.tgz"
  sha256 "9cdd61862facf662427a9a95b2d4a54d542cc47ebef8b0ba32cfae049c5dee8f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e278432f547fffc7a5e2859ce0912290ca1db5b96b3c5b99ff45408bdddb60c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e278432f547fffc7a5e2859ce0912290ca1db5b96b3c5b99ff45408bdddb60c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e278432f547fffc7a5e2859ce0912290ca1db5b96b3c5b99ff45408bdddb60c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3549624f8fb8d3b9cf625b786f1593e12d3939a129394c7fd600cce50bb52b7e"
    sha256 cellar: :any_skip_relocation, ventura:        "3549624f8fb8d3b9cf625b786f1593e12d3939a129394c7fd600cce50bb52b7e"
    sha256 cellar: :any_skip_relocation, monterey:       "3549624f8fb8d3b9cf625b786f1593e12d3939a129394c7fd600cce50bb52b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716453a660abba93b7226e9475480984cc46d82eecd1ef2e4ec17643acbe7709"
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
