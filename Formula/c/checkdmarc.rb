class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https://domainaware.github.io/checkdmarc/"
  url "https://files.pythonhosted.org/packages/df/06/e61a492a70a2126ac62fea72694aa0ce6f645cbe44ea513d9a68e2df822b/checkdmarc-5.3.1.tar.gz"
  sha256 "1d71e7fa611fa8faa36fad09416b5e2c3265d026d3b5209c051f4e292565e332"
  license "Apache-2.0"
  head "https://github.com/domainaware/checkdmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d22f2a531ff18bbf1fef11ae7da3bd47de84323c18570ab0605dce1025ab137"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67ef16c3fee807d9bdf5cdc172f7ab80d650bb07c80afb1522f83f48d8f35cc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b799a2b32be404eea62f364342f8b31210482f5fbc31dc9fb0166150e3b9b636"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c0d0aba92d9a90ea4c9eda1424b5085bfc8b50ad4d4c00a6e84a0b70cb4d1c0"
    sha256 cellar: :any_skip_relocation, ventura:        "112d26c09b2f4e370202e231f5efe5b98fe5b829b87e1ce9d095f644d824ecd4"
    sha256 cellar: :any_skip_relocation, monterey:       "98f5b01abc3226081df3a912298075c0716ee9dad14f0423c729b01b42697804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48c6901b59644db432ff9bd1066b49179b4cfdfc9586f78316483f83e58fee21"
  end

  depends_on "python-certifi"
  depends_on "python-cryptography"
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
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/76/f7/96907e9620a5d44dae7d8a22c412853dcb10ea764ef4116d452d0644c950/publicsuffixlist-0.10.0.20240214.tar.gz"
    sha256 "45a206c5f9c1eccf138481280cfb0a67c2ccafc782ef89c7fd6dc6c4356230fe"
  end

  resource "pyleri" do
    url "https://files.pythonhosted.org/packages/0e/94/fa146d2de46b78237562373a2bb9277d69e4149738a11b69c1f42ca64c33/pyleri-1.4.2.tar.gz"
    sha256 "18b92f631567c3c0dc6a9288aa9abc5706a8c1e0bd48d33fea0401eec02f2e63"
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
