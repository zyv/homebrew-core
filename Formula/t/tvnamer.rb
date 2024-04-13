class Tvnamer < Formula
  include Language::Python::Virtualenv

  desc "Automatic TV episode file renamer that uses data from thetvdb.com"
  homepage "https://github.com/dbr/tvnamer"
  url "https://files.pythonhosted.org/packages/7e/07/688dc96a86cf212ffdb291d2f012bc4a41ee78324a2eda4c98f05f5e3062/tvnamer-3.0.4.tar.gz"
  sha256 "dc2ea8188df6ac56439343630466b874c57756dd0b2538dd8e7905048f425f04"
  license "Unlicense"
  revision 6
  head "https://github.com/dbr/tvnamer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e672f525c0ebc2b890a6c1341a05d19b0cf17aa3698a39db3192f77bbc0a94a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b154512029949f5e824231825c5507e99e585d8e21c5ab04cac622eed1f84f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6ebc6af65cb260e4db4e22f7ee11f9fdcc49bbc526854b36d7c1aefe7e3b47f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e15af8ab54bd5b37ee2e046b3d3922af6768ea58419e590fa45594138ab38a82"
    sha256 cellar: :any_skip_relocation, ventura:        "fdc31d4cbb21340738dbe923238f5170d78830626409ca35540815f9369037ee"
    sha256 cellar: :any_skip_relocation, monterey:       "8a7ffce09ece55aa0f76159f463360f8a8da903ba71f79237349e0ce0326be77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdb156ffafb08a5bbfeea58f69ca33f3014008e5a1add188d1177c7a829ccbb4"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/0c/d4/bdc22aad6979ceeea2638297f213108aeb5e25c7b103fa02e4acbe43992e/requests-cache-0.5.2.tar.gz"
    sha256 "813023269686045f8e01e2289cc1e7e9ae5ab22ddd1e2849a9093ab3ab7270eb"
  end

  resource "tvdb-api" do
    url "https://files.pythonhosted.org/packages/a9/66/7f9c6737be8524815a02dd2edd3a24718fa786614573104342eae8d2d08b/tvdb_api-3.1.0.tar.gz"
    sha256 "f63f6db99441bb202368d44aaabc956acc4202b18fc343a66bf724383ee1f563"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    raw_file = testpath/"brass.eye.s01e01.avi"
    expected_file = testpath/"Brass Eye - [01x01] - Animals.avi"
    touch raw_file
    system bin/"tvnamer", "-b", raw_file
    assert_predicate expected_file, :exist?
  end
end
