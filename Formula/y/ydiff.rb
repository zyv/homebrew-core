class Ydiff < Formula
  include Language::Python::Virtualenv

  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/ydiff"
  url "https://files.pythonhosted.org/packages/22/e1/df78c47d98070228bc1589df6aa2b2c7ae1d4b35f9312dbb2d7a122a0f19/ydiff-1.3.tar.gz"
  sha256 "8a2e84588ef31d3e525700fa964b1f9aab61f0c9c46281e05341a56e01dcd7b8"
  license "BSD-3-Clause"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb25d01f9f13cb4a7b3c0fe4b57e3443d0735bc683f648d613b276ef9973b591"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0885ed807f5e2f7bfd9fcd36ec44a38a0102adf497be77ceb71e5aa5ae2b55ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b1bc22276a6eb855f2064baf5dc51f0273e62c0e58fd66cc32cad6a1dc0d5a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc4c7a731e914f8e4411054a86354601d983f710550f41ceb2b3da6933b3cc94"
    sha256 cellar: :any_skip_relocation, ventura:        "5f2cbff608b7dbc2c1cf6a6ce2e4a15891675ad498f21a6415223785c65e2702"
    sha256 cellar: :any_skip_relocation, monterey:       "790098af5d0271224baa53cf67bf8649c6f55ecf33e07e2a55f5e5a876045c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df568445b19a3c7c4931d8ed811befb73b45fad50a0210c52bda2ae3a0ebddb9"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/ydiff -cnever", diff_fixture)
  end
end
