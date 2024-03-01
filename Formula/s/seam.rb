require "language/node"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.48.tgz"
  sha256 "1c66f08262161d6e6188b8ae8443e16062e92163ed1fc072052fc1040a31f455"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "362c76a77569cb1e7aeba4e13ad7abf6cf6d5af080aac033d3208f82b11ac069"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "362c76a77569cb1e7aeba4e13ad7abf6cf6d5af080aac033d3208f82b11ac069"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "362c76a77569cb1e7aeba4e13ad7abf6cf6d5af080aac033d3208f82b11ac069"
    sha256 cellar: :any_skip_relocation, sonoma:         "aacdef49b50859e945ac11014d5fdde2fed2a5bf59e0a3d75ffb108b10b04c36"
    sha256 cellar: :any_skip_relocation, ventura:        "aacdef49b50859e945ac11014d5fdde2fed2a5bf59e0a3d75ffb108b10b04c36"
    sha256 cellar: :any_skip_relocation, monterey:       "aacdef49b50859e945ac11014d5fdde2fed2a5bf59e0a3d75ffb108b10b04c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "362c76a77569cb1e7aeba4e13ad7abf6cf6d5af080aac033d3208f82b11ac069"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}/seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end
