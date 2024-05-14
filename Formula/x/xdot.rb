class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/38/76/0503dddc3100e25135d1380f89cfa5d729b7d113a851804aa98dc4f19888/xdot-1.4.tar.gz"
  sha256 "fb029dab92b3c188ad5479108014edccb6c7df54f689ce7f1bd1c699010b7781"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/xdot.py.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5fa743c1cd886c911a0b7be7e0c0ce047cb2137456dffd781df01a70bec5139"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5fa743c1cd886c911a0b7be7e0c0ce047cb2137456dffd781df01a70bec5139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5fa743c1cd886c911a0b7be7e0c0ce047cb2137456dffd781df01a70bec5139"
    sha256 cellar: :any_skip_relocation, sonoma:         "6388495e914b6a72dc929489a99f638305c3bbc1a3d9afe7f8e825dc844345e5"
    sha256 cellar: :any_skip_relocation, ventura:        "6388495e914b6a72dc929489a99f638305c3bbc1a3d9afe7f8e825dc844345e5"
    sha256 cellar: :any_skip_relocation, monterey:       "6388495e914b6a72dc929489a99f638305c3bbc1a3d9afe7f8e825dc844345e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94dafcfccfdbb31a72bfbdd8840569763505d54610b024969e2b2cffa5fe8898"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/83/5a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9f/graphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Disable test on Linux because it fails with this error:
    # Gtk couldn't be initialized. Use Gtk.init_check() if you want to handle this case.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"xdot", "--help"
  end
end
