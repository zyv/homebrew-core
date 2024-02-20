class Ccm < Formula
  include Language::Python::Virtualenv

  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/riptano/ccm"
  url "https://files.pythonhosted.org/packages/f1/12/091e82033d53b3802e1ead6b16045c5ecfb03374f8586a4ae4673a914c1a/ccm-3.1.5.tar.gz"
  sha256 "f07cc0a37116d2ce1b96c0d467f792668aa25835c73beb61639fa50a1954326c"
  license "Apache-2.0"
  revision 3
  head "https://github.com/riptano/ccm.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4b776344544f21c1ed435bb6fbe9204b1ceff6bcd8a55153bdef9fa1e7a7c96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be900b95dd8a12fc425d2c9a23b4a1e4d81fea39100373be42323a0d52981995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3724c35c53d050b014872b32999b494e78bf2e37125d74af77d2c06e87349c28"
    sha256 cellar: :any_skip_relocation, sonoma:         "77994bbe83114d1d54aae4a85afc4ffe5a653643a2a482ea9bc5ebb5ef46d222"
    sha256 cellar: :any_skip_relocation, ventura:        "87b39b4e470135d8aff191c9d9296cb46bcef172a7047f7d97e50a3b344b885d"
    sha256 cellar: :any_skip_relocation, monterey:       "22e13ceb8aa99807bcdc58a69fe92b5ee701a0d2abdb1e5e03904a99a8f6fcd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed9334e015be0e1bf2997b2908b20536fcdf68da63e5ef3125dfd270fc66feb8"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/59/28/3e0ea7003910166525304b65a8ffa190666b483c2cc9c38ed5746a25d0fd/cassandra-driver-3.29.0.tar.gz"
    sha256 "0a34f9534356e5fd33af8cdda109d5e945b6335cb50399b267c46368c4e93c98"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/cf/21/58251b3de99e0b5ba649ff511f7f9e8399c3059dd52a643774106e929afa/geomet-0.2.1.post1.tar.gz"
    sha256 "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ccm", 1)
  end
end
