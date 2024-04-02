class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://files.pythonhosted.org/packages/15/f5/8f3bd0f4a927b1fbb3a5e6a5b036f29e4263977fb167b301bc4a5f4db2b9/awslogs-0.15.0.tar.gz"
  sha256 "19f223bb1c0703cea0689d94b1d293006529095e6ab8971f6b52289a2e545dd5"
  license "BSD-3-Clause"
  head "https://github.com/jorgebastida/awslogs.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f680cfd6df8af3076657fb62141c69262dbe899a47eb1379ea412f4e93ac895"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "358a9731c9262a5355ae501ceb6dfc996293255fb2a5eb0e9e306024319e6c95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be1287bc201c2035301b093033c36af1a03635fcf89391332ac03fcc4a616fcd"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b8e432c5a19e08fccee7c6c04f608bc00c1c271a942cc19edec0b267301200e"
    sha256 cellar: :any_skip_relocation, ventura:        "5bd3156489fe2de2a8f54aab36e30f1ee290e9cb1e54b6f3a4a37591f12d334a"
    sha256 cellar: :any_skip_relocation, monterey:       "9c4966989fac868acbb9e00b05df4d989596c2f6c5e6995da546e19bce0aa824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a326b37cc4afce334d703f19f829ab7fcf87d51b78772ce760a8730932d665c4"
  end

  depends_on "python@3.12"

  uses_from_macos "zlib"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/50/71/4382017bf4ddb37250966b077e3347e944522873aea49de546053bbd71fb/boto3-1.34.75.tar.gz"
    sha256 "eaec72fda124084105a31bcd67eafa1355b34df6da70cadae0c0f262d8a4294f"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/8b/c0/14e3d01ff8a58adef587f032e04486cccb4e8137b132f65ddb8123c5578c/botocore-1.34.75.tar.gz"
    sha256 "06113ee2587e6160211a6bd797e135efa6aa21b5bde97bf455c02f7dff40203c"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/10/56/d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764/termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version")

    assert_match "You must specify a region", shell_output("#{bin}/awslogs groups 2>&1", 1)
  end
end
