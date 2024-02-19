class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/5a/92/6ca8c647413857677dba60998ee064a02af5a8a9e36a0285d9da3cc915c7/gallery_dl-1.26.8.tar.gz"
  sha256 "b5f3662a058aaf64c640d82f0bfaa8dbe0ef8a3e0b50bd19cbbee67d371c8b69"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daf71f4a524a6e508f1ff81177dc19aed29f7e133bdba1916ee82ee66b0b808e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28a77507c6a050c3179a624f8e889c89ab5aaa92213401cff59550cb7d41828c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d391bceec165b759ef5ff65b2b055a7b9e443194121c963b5704f5f60008713"
    sha256 cellar: :any_skip_relocation, sonoma:         "31c970fcc16975b61229077364642ded1c8c9d728e9f7c7bd9ddd21d415654a0"
    sha256 cellar: :any_skip_relocation, ventura:        "c020b3c4b3869e5c383b0f4a2efb0ef02e37157ae577b25958a7b6bcf0a005d0"
    sha256 cellar: :any_skip_relocation, monterey:       "bcb40f370631a6c9e966ddf2f20315ab4c799ff2cd13a6a88d486b989897223e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7f22aaebef3667ef7da411caa0537dae5c1968a773a0b93c246d583098b3b83"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
