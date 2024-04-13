class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/19/f0/4213fadbae8ab5945786c4020f7cb6202e828d90df05be8f2dbc9395bcd9/pyinstaller-6.6.0.tar.gz"
  sha256 "be6bc2c3073d3e84fb7148d3af33ce9b6a7f01cfb154e06314cd1d4c05798a32"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "451e0b4f478ba86908ef79cf96f50d2820509b11327abcabf0a3c77cab14f241"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d74b92ca48fee0c19d9116b6f7bd28cb47929994f0d45edcf455600e585fd765"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d71e1db04cc2d03cd016ad5a7b4a70201a382619e8fa66502fa350191ff7ea3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d52d765ddee6d99edfb30fcc507bdf30d2d75219c5c625a8f1eac6046a439b1"
    sha256 cellar: :any_skip_relocation, ventura:        "e72016999bfd65f1967af1fd92debe97f2c33c69846c719ab0a81e65106a0e5e"
    sha256 cellar: :any_skip_relocation, monterey:       "a9ad57c685bc11ad21d9c1d199c76eb6ea17e975c1853e7b9cb78c0e930f06cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cc112cf162bdc41cbfcf34f583da654f82148f0f03427fa66cbaef752798772"
  end

  depends_on "python@3.12"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/63/e2/11b016c54e9c79d4027693241f3fbfe326006bc030f94c43363491d3ba98/pyinstaller-hooks-contrib-2024.3.tar.gz"
    sha256 "d18657c29267c63563a96b8fc78db6ba9ae40af6702acb2f8c871df12c75b60b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  def install
    cd "bootloader" do
      system "python3.12", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
