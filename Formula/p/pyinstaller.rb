class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/3e/c8/7acd0d98bc71585a2ca08b959951a4a76d5289c9bef3d40ed434694a3ee4/pyinstaller-6.7.0.tar.gz"
  sha256 "8f09179c5f3d1b4b8453ac61adfe394dd416f9fc33abd7553f77d4897bc3a582"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "649535e726d32491954456b0154cb9ae974b3de8add5b0e75c8c74b4a38fc41e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "351d6e6b5b8775284cad34e407f1ec7ab01b67cf5face5390dc27158a2e9c8e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26dfa9e8392eb269cc04cbf5bcfa949f124fca468960840beb682da51763150f"
    sha256 cellar: :any_skip_relocation, sonoma:         "56a9fe0404e9935c516ec41bf5ed102a5b4f2929ecf1764d5c156c9f9d230c99"
    sha256 cellar: :any_skip_relocation, ventura:        "4e56d29482d43e0fd3f6bd373ee504989ca28e4277b12712ffe0b5825a82c2b7"
    sha256 cellar: :any_skip_relocation, monterey:       "bb37923f17b5ff4fe48cfb0996401cba5bfb80a2c80f79f414278870e94ebe61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7254f412eea03a718f303d9f7615fcf71efefd51aaea2c014b6bf306492e5c67"
  end

  depends_on "python@3.12"

  uses_from_macos "zlib"

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
    url "https://files.pythonhosted.org/packages/9a/b1/ea0917424a3f1b4ed760957415c5d02c081a4621300f89bd9caa9ff27b2e/pyinstaller_hooks_contrib-2024.6.tar.gz"
    sha256 "3c188b3a79f5cd46d96520df3934642556a1b6ce8988ec5bbce820ada424bc2b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
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
