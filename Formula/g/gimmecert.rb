class Gimmecert < Formula
  include Language::Python::Virtualenv

  desc "Quickly issue X.509 server and client certificates using locally-generated CA"
  homepage "https://projects.majic.rs/gimmecert"
  url "https://files.pythonhosted.org/packages/94/b3/f8d0d4fc8951d7ff02f1d3653ba446ad0edf14ab1a18cff4fbe1d1b62086/gimmecert-1.0.0.tar.gz"
  sha256 "eb00848fab5295903b4d5ef997c411fe063abc5b0f520a78ca2cd23f77e3fd99"
  license "GPL-3.0-or-later"

  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output1 = shell_output(bin/"gimmecert init")
    assert_match "CA hierarchy initialised using 2048-bit RSA keys", output1

    output2 = shell_output(bin/"gimmecert status")
    assert_match "No server certificates have been issued", output2

    assert_predicate testpath/".gimmecert/ca/level1.key.pem", :exist?
    assert_predicate testpath/".gimmecert/ca/level1.cert.pem", :exist?
    assert_predicate testpath/".gimmecert/ca/chain-full.cert.pem", :exist?
  end
end
