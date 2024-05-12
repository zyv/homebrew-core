require "language/node"

class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-5.0.0.tgz"
  sha256 "82468e44d6cf4d50c6f61b46e2a1651ef0779851df722a7d79e265ead591ba59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46a98dfca926afea2ffa8460dd08defa0e8f31beca2db710560e91957aa2cd23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46a98dfca926afea2ffa8460dd08defa0e8f31beca2db710560e91957aa2cd23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46a98dfca926afea2ffa8460dd08defa0e8f31beca2db710560e91957aa2cd23"
    sha256 cellar: :any_skip_relocation, sonoma:         "afca708f20dde07ddb915d4af0b3c5209735046d99ac0cacf832a77b08effb1a"
    sha256 cellar: :any_skip_relocation, ventura:        "afca708f20dde07ddb915d4af0b3c5209735046d99ac0cacf832a77b08effb1a"
    sha256 cellar: :any_skip_relocation, monterey:       "afca708f20dde07ddb915d4af0b3c5209735046d99ac0cacf832a77b08effb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46a98dfca926afea2ffa8460dd08defa0e8f31beca2db710560e91957aa2cd23"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_config = testpath/".solhint.json"
    test_config.write <<~EOS
      {
        "rules": {
          "no-empty-blocks": "error"
        }
      }
    EOS

    (testpath/"test.sol").write <<~EOS
      pragma solidity ^0.4.0;
      contract Test {
        function test() {
        }
      }
    EOS
    assert_match "error  Code contains empty blocks  no-empty-blocks",
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1", 1)
  end
end
