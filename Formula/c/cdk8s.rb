require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.131.tgz"
  sha256 "135ba0433354c85fedd6b415f363300df39b4f81ee983ef8b8fdf1235debc990"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb6e2d822825bf85a1ac300bd5d9441f1c7a312b3bb4810dc580ccfe4ce7c86e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb6e2d822825bf85a1ac300bd5d9441f1c7a312b3bb4810dc580ccfe4ce7c86e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb6e2d822825bf85a1ac300bd5d9441f1c7a312b3bb4810dc580ccfe4ce7c86e"
    sha256 cellar: :any_skip_relocation, sonoma:         "06808104115574404a2a2524665ea356b3e5170ee735934c6c885860258d8336"
    sha256 cellar: :any_skip_relocation, ventura:        "06808104115574404a2a2524665ea356b3e5170ee735934c6c885860258d8336"
    sha256 cellar: :any_skip_relocation, monterey:       "06808104115574404a2a2524665ea356b3e5170ee735934c6c885860258d8336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f480325a7fb6c009f4587696d4f3758976a6aebadc3db756120b554110897e"
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
