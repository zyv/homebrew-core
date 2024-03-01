class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "d4c6bc58f2ee51b93007cf678cc3ed07f15317a892faca3b4098c30afa4e537f"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67cb8d46135477feda8dabc97a748d003ba9fc25ad6b74cdd265e7af98d6087a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "841d2dc6b4a5808a3a9583d4fd465c5e7f5a6ffa4e243ca9b16f4ca169d555cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b246c45262229a939028bb58de0b7e3394c7f3df929f41bc4409e1ea65af0249"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d8632555a00e4b6997b9a5a011709a7bca304f084458ad0131d179069332738"
    sha256 cellar: :any_skip_relocation, sonoma:         "10b75abd0088c64e876e2571099e7892e379cfb909c336deb0eba9de5839a42d"
    sha256 cellar: :any_skip_relocation, ventura:        "f51d41d50a6564647451371885baf6182c03de1688ce75782d5813d8ca070339"
    sha256 cellar: :any_skip_relocation, monterey:       "01b83d69c3587ac988d64ca76da2809cda605bf1237003545995a0f06c8948a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c53df68bc21d836fae466d49f44066464f9f78eb1cdbcaf8f41bb80d1f90d845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920f39756818dd331a6f90a616f7024c0624a9dd00763f39a22aa5201e7ca5ba"
  end

  depends_on "go" => :build
  depends_on "truffle" => :test
  depends_on "crytic-compile"

  conflicts_with "bash-completion", because: "both install `medusa` bash completion"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"medusa", "completion", shells: [:bash, :zsh])
  end

  test do
    system "truffle", "init"

    (testpath/"contracts/test.sol").write <<~EOS
      pragma solidity ^0.8.0;
      contract Test {
        function assert_true() public {
          assert(true);
        }
        function assert_false() public {
          assert(false);
        }
      }
    EOS

    fuzz_output = shell_output("#{bin}/medusa fuzz --compilation-target #{testpath} --test-limit 100", 7)
    assert_match(/PASSED.*assert_true/, fuzz_output)
    assert_match(/FAILED.*assert_false/, fuzz_output)
  end
end
