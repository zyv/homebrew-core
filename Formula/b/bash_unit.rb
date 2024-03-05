class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/pgrange/bash_unit"
  url "https://github.com/pgrange/bash_unit/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "750983353e79ad83cb3ec093406be7306bd1d90a64f77977b29bb968d66731f6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a2fa11fc5dfba5570709f597c9f3fcaac5189592fee2cd88c8d0e8696de10e4"
  end

  uses_from_macos "bc" => :test

  def install
    bin.install "bash_unit"
    man1.install "docs/man/man1/bash_unit.1"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      test_addition() {
        RES="$(echo 2+2 | bc)"
        assert_equals "${RES}" "4"
      }
    EOS
    assert "addition", shell_output("#{bin}/bash_unit test.sh")
  end
end
