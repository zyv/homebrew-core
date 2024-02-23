require "language/node"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.41.tgz"
  sha256 "7c8972e9d05bc679399d7bc2ef26bdb094ba22841ce76bdc9139666c236f1dde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9c9206f8a9af9c69382d4348bea2fa0d3bc7c3309428d768c59b608ea265dfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9c9206f8a9af9c69382d4348bea2fa0d3bc7c3309428d768c59b608ea265dfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9c9206f8a9af9c69382d4348bea2fa0d3bc7c3309428d768c59b608ea265dfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2861bc41403b0de627f02d359950414dc6e5ea33105630311eb9e87cdf1fa4ae"
    sha256 cellar: :any_skip_relocation, ventura:        "2861bc41403b0de627f02d359950414dc6e5ea33105630311eb9e87cdf1fa4ae"
    sha256 cellar: :any_skip_relocation, monterey:       "2861bc41403b0de627f02d359950414dc6e5ea33105630311eb9e87cdf1fa4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c9206f8a9af9c69382d4348bea2fa0d3bc7c3309428d768c59b608ea265dfc"
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
