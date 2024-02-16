require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.50.tgz"
  sha256 "c699ba65ed246fef050a515318b8521fe00e744e21333e9b6f4270d8d09340ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3eb3c505b1d97ed30ea86b038a90b0aa5d7d71b7ca35eac45e57f75b4e58751c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3eb3c505b1d97ed30ea86b038a90b0aa5d7d71b7ca35eac45e57f75b4e58751c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eb3c505b1d97ed30ea86b038a90b0aa5d7d71b7ca35eac45e57f75b4e58751c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2dd6dbaff4ebc44b9b582ca458eae848cd0955dbba36908dda3d97f6a59884b"
    sha256 cellar: :any_skip_relocation, ventura:        "f2dd6dbaff4ebc44b9b582ca458eae848cd0955dbba36908dda3d97f6a59884b"
    sha256 cellar: :any_skip_relocation, monterey:       "f2dd6dbaff4ebc44b9b582ca458eae848cd0955dbba36908dda3d97f6a59884b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eb3c505b1d97ed30ea86b038a90b0aa5d7d71b7ca35eac45e57f75b4e58751c"
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
