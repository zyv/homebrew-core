class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://fortls.fortran-lang.org/"
  url "https://files.pythonhosted.org/packages/7a/3f/db215a89836cf9c9e7d2039f9ded31511fdaeceb63bb8bc8d0e01714b1a0/fortls-3.1.0.tar.gz"
  sha256 "e38f9f6af548f78151d54bdbb9884166f8d717f8e147ab1e2dbf06b985df2c6d"
  license "MIT"
  head "https://github.com/fortran-lang/fortls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2699022c66461a29076a279c94e95bad33596a8363d48444a41ac91f61c1506b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cec00bf6373b3343bf431526da85743dd8b583d4dac9a670014e7bb559e2c3cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "601c1c5f109d425b9daf72a71ed09e765f376dff843e00e7159b08624f4cf0a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "120a913699c53a90de4f563beb948ae9689af12cbe02d2ac36117839861c05f3"
    sha256 cellar: :any_skip_relocation, ventura:        "63454492686ae3963eeb465dfe864138302b86a8447d9bba8b748695be61d8d2"
    sha256 cellar: :any_skip_relocation, monterey:       "7fbeeb67ecae5c43708f3ffcaeb3c5f713dbe0cfa46701a34dbd23930b11803a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7720090598a9f6830c39bc83ca7c96add500cccf07e8cc2a0bf72883a1e2cec"
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
