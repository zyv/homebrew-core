class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https://domainaware.github.io/checkdmarc/"
  url "https://files.pythonhosted.org/packages/df/06/e61a492a70a2126ac62fea72694aa0ce6f645cbe44ea513d9a68e2df822b/checkdmarc-5.3.1.tar.gz"
  sha256 "1d71e7fa611fa8faa36fad09416b5e2c3265d026d3b5209c051f4e292565e332"
  license "Apache-2.0"
  revision 1
  head "https://github.com/domainaware/checkdmarc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e879dc5e0eb5e96fa1b51aa35748d5777e56b6db3e314862fe4c3c14a4d7d811"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d89cb1eca4f85275435a40929235b1f118266db215e7133c57ad4955a3dbc3b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ace84c6362acb046f17d41a1c45ad653c099b0424b486ee07157964799964e07"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a794d3fbef096e700eb41af80ec5bc2a1c5a902df2890b732b51760e958ed09"
    sha256 cellar: :any_skip_relocation, ventura:        "b83b7ffc0e31c3c64fdc018e09b6ca36bb807724b056a830a1da88b8f81b8e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "87056d4ef13932674a2f4b65a4993ccfd71cd5f1743d7c26464c930a002c6ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edd4eb656db150fb1c31164af9cc5622e14c7cc51a9d85e7ca9e19971ece9d88"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "expiringdict" do
    url "https://files.pythonhosted.org/packages/fc/62/c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7/expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/3a/0f/b8cf593fda6c7525ccc444d15f42f2aada2f3d9a34297f8c622696460102/publicsuffixlist-0.10.0.20240412.tar.gz"
    sha256 "1b685d974dbd3258ab1c7f473449cf2a55275a74a995b60a8410f0f07d7f5b78"
  end

  resource "pyleri" do
    url "https://files.pythonhosted.org/packages/93/6a/4a2a8a05a4945b253d40654149056ae03b9d5747f3c1c423bb93f1e6d13f/pyleri-1.4.3.tar.gz"
    sha256 "17ac2a2e934bf1d9432689d558e9787960738d64aa789bc3a6760c2823cb67d2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "timeout-decorator" do
    url "https://files.pythonhosted.org/packages/80/f8/0802dd14c58b5d3d72bb9caa4315535f58787a1dc50b81bbbcaaa15451be/timeout-decorator-0.5.0.tar.gz"
    sha256 "6a2f2f58db1c5b24a2cc79de6345760377ad8bdc13813f5265f6c3e63d16b3d7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/checkdmarc -v")

    assert_match "\"base_domain\": \"example.com\"", shell_output("#{bin}/checkdmarc example.com")
  end
end
