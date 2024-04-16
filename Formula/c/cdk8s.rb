require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.101.tgz"
  sha256 "07e1f8a6b1df42349c2e4a3f659c4cb47f47d366b0e4662ca985f64709e39515"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ed14261439ecf8c707c0c68af402b829e5799b69376717ee3b98c036ccaccb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ed14261439ecf8c707c0c68af402b829e5799b69376717ee3b98c036ccaccb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ed14261439ecf8c707c0c68af402b829e5799b69376717ee3b98c036ccaccb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6026b1a928c26a9cd1d2e9644d440c07bd0fe06b681b29a896bf02b33bfda60"
    sha256 cellar: :any_skip_relocation, ventura:        "c6026b1a928c26a9cd1d2e9644d440c07bd0fe06b681b29a896bf02b33bfda60"
    sha256 cellar: :any_skip_relocation, monterey:       "c6026b1a928c26a9cd1d2e9644d440c07bd0fe06b681b29a896bf02b33bfda60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ed14261439ecf8c707c0c68af402b829e5799b69376717ee3b98c036ccaccb7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
