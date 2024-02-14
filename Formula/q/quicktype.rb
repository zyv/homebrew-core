require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.82.tgz"
  sha256 "f685b825b76345a6c25f7bb3249fcd3d86cb013b8eac13f352833277f378d68a"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83b78f4baf16d8afee97af538ecc669cda6ae633bdab2a2be93515cc7d9f7529"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83b78f4baf16d8afee97af538ecc669cda6ae633bdab2a2be93515cc7d9f7529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b78f4baf16d8afee97af538ecc669cda6ae633bdab2a2be93515cc7d9f7529"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9c5182493b7b7668003180adafd3ae337d0465014b2c8e6cabccd5b11d0596d"
    sha256 cellar: :any_skip_relocation, ventura:        "b9c5182493b7b7668003180adafd3ae337d0465014b2c8e6cabccd5b11d0596d"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c5182493b7b7668003180adafd3ae337d0465014b2c8e6cabccd5b11d0596d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b78f4baf16d8afee97af538ecc669cda6ae633bdab2a2be93515cc7d9f7529"
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
