require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.43.0.tgz"
  sha256 "d989845aa5a8c715856ae8366a169b6038935d3a1e4a57f25498a041c505b61d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "668a985a9bddaa18cff3d2f482e24de2f1e53a4da5ecffc07e5bb355c9bffd60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "668a985a9bddaa18cff3d2f482e24de2f1e53a4da5ecffc07e5bb355c9bffd60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3cb8fdc01c94feaf02c558ed5f11a5fdd8d9b0b0033c5cebf8592b5d65b12df"
    sha256 cellar: :any_skip_relocation, sonoma:         "43167b495984a1c28d66e2508b0294eb396e827b24b7f90f6c414369003b664f"
    sha256 cellar: :any_skip_relocation, ventura:        "43167b495984a1c28d66e2508b0294eb396e827b24b7f90f6c414369003b664f"
    sha256 cellar: :any_skip_relocation, monterey:       "43167b495984a1c28d66e2508b0294eb396e827b24b7f90f6c414369003b664f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "577ed2d74c5693ffb1c64e071a40373f27a6304bc0270b42a3c64fb9d3dcf38b"
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
