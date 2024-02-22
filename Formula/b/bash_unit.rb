class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/pgrange/bash_unit"
  url "https://github.com/pgrange/bash_unit/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "c601ec2bcf3465bd46c15ea32674062c991e7a53975582dba4a51c805d94b054"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b32bfdb5f5ec420b9186e4780075c2ff6c71122a0615b031c016090da668a0f"
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
