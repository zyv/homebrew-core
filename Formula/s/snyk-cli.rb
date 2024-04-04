require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1286.4.tgz"
  sha256 "31beb753bf5df8d35c1d77874e86e401eb3d151c0f04a784ff8efcd44370f657"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9ed6226cf317272bcbc4a61a20134719f5ec6c7936610134bcb6700f1631995"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33d834c2619a0a2bad2209a3b4e3b9f4de040939fbe45d4104c500ed973bbe0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f17af73cd8c9575290aabb3a833f82ee4a474af76aba27ecffb580fe534b6180"
    sha256 cellar: :any_skip_relocation, sonoma:         "91c721de1199edc15d7cc0ef004e866a7d7d3a65226e43bbd167eeaa5f0d8ee5"
    sha256 cellar: :any_skip_relocation, ventura:        "b25ae08942009bad391d3adaeaeb2ed8533ca7a1d534fb633b748fa47678b054"
    sha256 cellar: :any_skip_relocation, monterey:       "e51377a95095c79bfd1a5970be1a24501bda283ee755152bff9ed26fa6c68764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b69be9a7d5b0808816923c3f5e9626a3ca9df5736f5c43ae44a28a36024b2c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
