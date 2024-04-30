require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.158.tgz"
  sha256 "dec5cf47df3272c419a73f7f273844596b89d59172a27ae2c6d8b6ba69fe9530"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "772a85ca242c1895eeb1a7f6a693a6a851d86685b442bcccca6877ed4b3bf6ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772a85ca242c1895eeb1a7f6a693a6a851d86685b442bcccca6877ed4b3bf6ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "772a85ca242c1895eeb1a7f6a693a6a851d86685b442bcccca6877ed4b3bf6ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa1a21761ae307742a4d94cb4dd18a7d3d074a150f461793b3b20ce9bc2b84ba"
    sha256 cellar: :any_skip_relocation, ventura:        "fa1a21761ae307742a4d94cb4dd18a7d3d074a150f461793b3b20ce9bc2b84ba"
    sha256 cellar: :any_skip_relocation, monterey:       "fa1a21761ae307742a4d94cb4dd18a7d3d074a150f461793b3b20ce9bc2b84ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "772a85ca242c1895eeb1a7f6a693a6a851d86685b442bcccca6877ed4b3bf6ec"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
