class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://fortls.fortran-lang.org/"
  url "https://files.pythonhosted.org/packages/94/0c/80c669ecf7ae6b45c2e1fa2313d41af1e1c7a3e4f68e2fc9acec00300938/fortls-3.0.0.tar.gz"
  sha256 "1cf560b56aa74221d93d414b27f0d43c0e2475addcf1c1622713017c5bfbef01"
  license "MIT"
  head "https://github.com/fortran-lang/fortls.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f72f3698e59bbac8d6f18cc0837a069f780677fb2eba3b4ad1a7c54159c9a511"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7251adffa56e231b0fd92d1b1bb862dd60d8d0453757e4e8956a97e2e949238a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e3d8d40a2958cdac989492c3c547074c1e1a4aeecfef2b4b8a645f5c6cab97c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1e3429b82468af4bc8df61ca17d26184aeeabdea52dd24cccae1149739b2116"
    sha256 cellar: :any_skip_relocation, ventura:        "297dbb38409899d4641895bc9ea234813ee91ed00340a333d2d0063afb37d259"
    sha256 cellar: :any_skip_relocation, monterey:       "d20219ad11612fd7339f2c292dfa2dd62a9f264be2f2c5bdd9f65d951c9c6d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec87f2bc7d3c8013ca32e1bc113d6c9d82a4080bd6bb1de170d1ab9c59ce7fa"
  end

  depends_on "python@3.12"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https://files.pythonhosted.org/packages/91/59/51b032d53212a51f17ebbcc01bd4217faab6d6c09ed0d856a987a5f42bbc/json5-0.9.25.tar.gz"
    sha256 "548e41b9be043f9426776f05df8635a00fe06104ea51ed24b67f908856e151ae"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def install
    virtualenv_install_with_resources

    # Disable automatic update check
    (bin/"fortls").unlink
    (bin/"fortls").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/python3 -m fortls --disable_autoupdate "$@"
    EOS
  end

  test do
    system bin/"fortls", "--help"
    (testpath/"test.f90").write <<~EOS
      program main
      end program main
    EOS
    system bin/"fortls", "--debug_filepath", testpath/"test.f90", "--debug_symbols", "--debug_full_result"
  end
end
