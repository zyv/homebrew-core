require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.49.tgz"
  sha256 "84911e41af660b26486f5737f8b412ce4c9894c1d29c3a383dd522f2a5797e52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2fd232d4ef84c23ef2723f82ec00cc0c00e3129cbde39470a8792d013f8348e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2fd232d4ef84c23ef2723f82ec00cc0c00e3129cbde39470a8792d013f8348e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2fd232d4ef84c23ef2723f82ec00cc0c00e3129cbde39470a8792d013f8348e"
    sha256 cellar: :any_skip_relocation, sonoma:         "595eb0d4d61971e495b04a2e895622e0866a6e103b10118e8a21ef0eb4495a86"
    sha256 cellar: :any_skip_relocation, ventura:        "595eb0d4d61971e495b04a2e895622e0866a6e103b10118e8a21ef0eb4495a86"
    sha256 cellar: :any_skip_relocation, monterey:       "595eb0d4d61971e495b04a2e895622e0866a6e103b10118e8a21ef0eb4495a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2fd232d4ef84c23ef2723f82ec00cc0c00e3129cbde39470a8792d013f8348e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
