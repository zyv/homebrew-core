class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/2d/88/ce119d3090f2293b0e900f9eed31bbbb0138a2a392f2d1650ab7f526bd9e/xonsh-0.13.3.tar.gz"
  sha256 "f4cb0b9900943acf224e690ade3db670581dd1ce8e2e1fab9ac80ed516259a94"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ffd501c2ad845c8e07e26c2f40db82700404c80cce98ba7e16277932e0c3ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3caacabafc9e982889f5041812ab26089b55d545c8514e29b48c85e7df437531"
    sha256 cellar: :any_skip_relocation, monterey:       "9be10b6b31acab3a55047186be6e5069d38e5397388eb2c212bbd4477a192caa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ea75ff561c34179854d42896833dced9263b85309b97d841ef0c6b219a65b87"
    sha256 cellar: :any_skip_relocation, catalina:       "dba364334afb3eeb3bcb3cd2b04ab8a93d01cf30ec4b89bcadf6dd0188a54072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea165a12f660f5bd0b05c2987f6f1f61df32e7efca738ce32106ca827823f7a1"
  end

  depends_on "pygments"
  depends_on "python@3.10"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/b5/47/ac709629ddb9779fee29b7d10ae9580f60a4b37e49bce72360ddf9a79cdc/setproctitle-1.3.2.tar.gz"
    sha256 "b9fb97907c830d260fa0658ed58afd48a86b2b88aac521135c352ff7fd3477fd"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
