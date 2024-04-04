require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.46.0.tgz"
  sha256 "ec28723601810d50f6732af5afdc7a204d514de01e599673417eaf3b386badee"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1eebb6396ed7e330a77fd1380176ac467991068978986e21d228ba4b94ec02b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1eebb6396ed7e330a77fd1380176ac467991068978986e21d228ba4b94ec02b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1eebb6396ed7e330a77fd1380176ac467991068978986e21d228ba4b94ec02b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f5d32e173352f3a08c22b9aa06a7d4553cdf3b2e7d1ce4fc179af4caf6b4fa9"
    sha256 cellar: :any_skip_relocation, ventura:        "9f5d32e173352f3a08c22b9aa06a7d4553cdf3b2e7d1ce4fc179af4caf6b4fa9"
    sha256 cellar: :any_skip_relocation, monterey:       "9f5d32e173352f3a08c22b9aa06a7d4553cdf3b2e7d1ce4fc179af4caf6b4fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f3a4849c91a30d6c0444e6a9b16c4df3cc30cfd852e93b36c5375cbc17b7ab"
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
