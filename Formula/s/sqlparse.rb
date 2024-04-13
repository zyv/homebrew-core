class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/50/26/5da251cd090ccd580f5cfaa7d36cdd8b2471e49fffce60ed520afc27f4bc/sqlparse-0.5.0.tar.gz"
  sha256 "714d0a4932c059d16189f58ef5411ec2287a4360f17cdd0edd2d09d4c5087c93"
  license "BSD-3-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7061e91efe5b616a451f7a4e967721ad0ae67aed00d5e5c443603d73982fa2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "892c320ee32baf6cfb2ad9d815216d3e4803e2ec46097c9eba3689e73eb0557e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8e0882905a4bfd486a9ebda993131b27d47604b718366dfa02d133c81ecb26e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1ba5fe923a6ae6ffb3409273c397e8649877b87321fd5881aee2223e7e6987e"
    sha256 cellar: :any_skip_relocation, ventura:        "d3a5702d9c63b5f4fcb82d2cc580e75699b5f0d126fca13ccccefc81fabd4ad7"
    sha256 cellar: :any_skip_relocation, monterey:       "c325acfdaa6597e241d93ed03922657d9f10d35fde65a6311d12594a7b011305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc7e6a0783b875007c8f7b20903dec0db716e172dd2a8f79495c77b03531815b"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    man1.install "docs/sqlformat.1"
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
