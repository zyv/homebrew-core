class Unoconv < Formula
  include Language::Python::Virtualenv

  desc "Convert between any document format supported by OpenOffice"
  homepage "https://github.com/unoconv/unoconv"
  url "https://files.pythonhosted.org/packages/ab/40/b4cab1140087f3f07b2f6d7cb9ca1c14b9bdbb525d2d83a3b29c924fe9ae/unoconv-0.9.0.tar.gz"
  sha256 "308ebfd98e67d898834876348b27caf41470cd853fbe2681cc7dacd8fd5e6031"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/unoconv/unoconv.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8167e5b24c8d2ce044195a705f0b5df7b78bb34c9f86de6d5764a3e252938c71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8167e5b24c8d2ce044195a705f0b5df7b78bb34c9f86de6d5764a3e252938c71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8167e5b24c8d2ce044195a705f0b5df7b78bb34c9f86de6d5764a3e252938c71"
    sha256 cellar: :any_skip_relocation, sonoma:         "06772dcf1d112d1050550833839d8a1c70fa780fe1cd8299d5a3cecaed3261fa"
    sha256 cellar: :any_skip_relocation, ventura:        "06772dcf1d112d1050550833839d8a1c70fa780fe1cd8299d5a3cecaed3261fa"
    sha256 cellar: :any_skip_relocation, monterey:       "06772dcf1d112d1050550833839d8a1c70fa780fe1cd8299d5a3cecaed3261fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8167e5b24c8d2ce044195a705f0b5df7b78bb34c9f86de6d5764a3e252938c71"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  def install
    virtualenv_install_with_resources
    man1.install "doc/unoconv.1"
  end

  def caveats
    <<~EOS
      In order to use unoconv, a copy of LibreOffice between versions 3.6.0.1 - 4.3.x must be installed.
    EOS
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoconv 2>&1")
  end
end
