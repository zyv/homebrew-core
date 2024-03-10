class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/af/9b/3ee5d8f46b41e81914ee64795da3469782a5c69d67bf7efba82770f81f00/PyQt-builder-1.16.0.tar.gz"
  sha256 "47bbd2cfa5430020108f9f40301e166cbea98b6ef3e53953350bdd4c6b31ab18"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3b07ba04d94369bb4bb119a9a15274f97f05ee4c0a2fb45b76becd8aa83891f9"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/99/85/261c41cc709f65d5b87669f42e502d05cc544c24884121bc594ab0329d8e/sip-6.8.3.tar.gz"
    sha256 "888547b018bb24c36aded519e93d3e513d4c6aa0ba55b7cc1affbd45cf10762c"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system libexec/"bin/python", "-c", "import pyqtbuild"
  end
end
