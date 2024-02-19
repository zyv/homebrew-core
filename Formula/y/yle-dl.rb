class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/5c/ba/ae9008b208cfc78f8de4b32ea98d4107d6bf940e5062f8985f70dd18b086/yle_dl-20240130.tar.gz"
  sha256 "fe871fe3d63c232183f52d234f3e54afa2cffa8aa697a94197d2d3947b19e37d"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e658ddd73cb19f6b64001113f25b44cad9b0a3202e4f80960057ac1989293e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10f5886900a8de7f2b2687b9f4667e59cee0b5c97e7f6bc1d80671083138ffd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00d490998e01c565ba104033e5078d8f2662121b059be10b34e2e1250d1733c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ace467ab97f097780a62c727851de7ab553dc202d864466ec8fb0e8d2e5f764"
    sha256 cellar: :any_skip_relocation, ventura:        "f7943694c6e3e351f5e1b396332ce49c29173598cc255c4eb3efd480f03765a2"
    sha256 cellar: :any_skip_relocation, monterey:       "e6fee0f7f0b821b876191a09097416922b97d94664f0ad472ccac00716d60900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7feb6a3e7c0a7f32a91bb7ecd8ad8337b39bd9824dde2962d35f90ebda124057"
  end

  depends_on "ffmpeg"
  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
