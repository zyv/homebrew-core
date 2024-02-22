class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/8e/9a/64e0e24972057276141403b5971e87d8f51c82ba3d027badc10f39e5524f/parliament-1.6.2.tar.gz"
  sha256 "05f9db2bda8d85f039dbe27716538f025b7cb973d336568762a06217e3b7e3ae"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4903250117d14108cbce48b8641c0cce39b8db655b7ef8cde880891a08031924"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6170e2fd168a33a53e9d02568577157721d495370e76f8f32ae45ec3981b3018"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a22c9654b94496ec83b25fb7a4c231996ea61c26f1dcc85df6c164d5298f0392"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d70c6559cb3eecd4c8716dea0f8c1a2f38589b3b18d33baaec91c6e2c75d163"
    sha256 cellar: :any_skip_relocation, ventura:        "9652b3de6b09b8f1bea8df6a4bf4a16af8fa3fbce4feafbb70bbf5417a5e230e"
    sha256 cellar: :any_skip_relocation, monterey:       "95beb0820b75d9e0cdb8ec2aec76ae1b493d348aba53154ff3d5e8cc98e01e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e15ede582b720bffeecac7914f2b8009cba8c044af544efc1c104641c1d29d4"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/89/51/8b7c07768bef5756cdc38b3168b228139d2ff1ddd782e515f1c0f2c35a2a/boto3-1.34.47.tar.gz"
    sha256 "7574afd70c767fdbb19726565a67b47291e1e35ec792c9fbb8ee63cb3f630d45"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/93/cf/8c9516f6b1fb859e7fcb7413942b51573b54113307a92db46a44497a3b96/botocore-1.34.47.tar.gz"
    sha256 "29f1d6659602c5d79749eca7430857f7a48dd02e597d0ea4a95a83c47847993e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "json-cfg" do
    url "https://files.pythonhosted.org/packages/70/d8/34e37fb051be7c3b143bdb3cc5827cb52e60ee1014f4f18a190bb0237759/json-cfg-0.4.2.tar.gz"
    sha256 "d3dd1ab30b16a3bb249b6eb35fcc42198f9656f33127e36a3fadb5e37f50d45b"
  end

  resource "kwonly-args" do
    url "https://files.pythonhosted.org/packages/ee/da/a7ba4f2153a536a895a9d29a222ee0f138d617862f9b982bd4ae33714308/kwonly-args-1.0.10.tar.gz"
    sha256 "59c85e1fa626c0ead5438b64f10b53dda2459e0042ea24258c9dc2115979a598"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}",
    pipe_output("#{bin}/parliament --string '{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}'").strip
  end
end
