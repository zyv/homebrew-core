require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.62.tgz"
  sha256 "05003657dfddb9181393e1277a57ff4ce2a9ee3f84c7af10a5d36ebb02f0a54d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "930f7621d662710091407c3b186e37a3f112e2eb282db891297313fd98cd5800"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "930f7621d662710091407c3b186e37a3f112e2eb282db891297313fd98cd5800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "930f7621d662710091407c3b186e37a3f112e2eb282db891297313fd98cd5800"
    sha256 cellar: :any_skip_relocation, sonoma:         "cadb2fbdc85f0973f5d5d70e37b6f9540a94a210d63efd58a6b27cc6f6d7dd7f"
    sha256 cellar: :any_skip_relocation, ventura:        "cadb2fbdc85f0973f5d5d70e37b6f9540a94a210d63efd58a6b27cc6f6d7dd7f"
    sha256 cellar: :any_skip_relocation, monterey:       "cadb2fbdc85f0973f5d5d70e37b6f9540a94a210d63efd58a6b27cc6f6d7dd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "930f7621d662710091407c3b186e37a3f112e2eb282db891297313fd98cd5800"
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
