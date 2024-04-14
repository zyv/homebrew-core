require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.144.tgz"
  sha256 "32864428060959a88fcc5549f8b2ed23f3bd4d79b3f21312ecec82eaa84c442f"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b730f3e1b2c5f8303ad133136076b31292ad761807ffc21f725db2d163f77f35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b730f3e1b2c5f8303ad133136076b31292ad761807ffc21f725db2d163f77f35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b730f3e1b2c5f8303ad133136076b31292ad761807ffc21f725db2d163f77f35"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d1fed09d3c4f096ad90e2f50802f390863a6e44b214ed40ecd4242f28e513f0"
    sha256 cellar: :any_skip_relocation, ventura:        "1d1fed09d3c4f096ad90e2f50802f390863a6e44b214ed40ecd4242f28e513f0"
    sha256 cellar: :any_skip_relocation, monterey:       "1d1fed09d3c4f096ad90e2f50802f390863a6e44b214ed40ecd4242f28e513f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b730f3e1b2c5f8303ad133136076b31292ad761807ffc21f725db2d163f77f35"
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
