class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https://github.com/miracle2k/tarsnapper"
  url "https://files.pythonhosted.org/packages/4e/c5/0a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fe/tarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b48aef71d275be4e640ed1f99dea73050cee3600f0745f5bbc9c99b36454957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2f9c0a3797364ca219a20d6200ad6f0005c81ba6010e572f300ef39ec31b68a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9abbdd4147588aec9a0b33a804e8d672494330c14d6ec0e6e6a78fded43c25e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d324865fef97a462dd0ca212179902e6f713da22769fb76477c0b8bd3d68314f"
    sha256 cellar: :any_skip_relocation, ventura:        "fb6d4a1fcf598f49d227d4921f844a80e0c22edf374a758b5a1981be24a2b838"
    sha256 cellar: :any_skip_relocation, monterey:       "12ef312292edb578e80d80f1ac2e7eaaad5ec1ddb446eda4a5e9dff8569be8bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e788ef51a4b7de45dcb87de4d509fe22852339b4257fa2946fb48113b01defc"
  end

  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tarsnap"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: tarsnapper", shell_output("#{bin}/tarsnapper --help")
  end
end
