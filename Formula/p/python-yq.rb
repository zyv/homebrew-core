class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/e1/4b/26a31d6016596d27a06f158ae04b7b27d3c51cd15e444a0d5dbac03c0298/yq-3.3.0.tar.gz"
  sha256 "d2ab562f11b1e0e5b9654b9b06d43f8a205269cc7bda2ce077325f5a123651dc"
  license "Apache-2.0"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sonoma:   "05e8bd1893802d621c4c64322bd254c4435a7d5237b8854bc8983192565ed63a"
    sha256 cellar: :any,                 arm64_ventura:  "8c4dcd5544310cfa1b86dc6fb848d65e056ef1ebd384659a9a938afed60cdbba"
    sha256 cellar: :any,                 arm64_monterey: "98df65b73ecf0ea502e18fc88b626b3ffd238934f47d125414ec71aa875da12c"
    sha256 cellar: :any,                 sonoma:         "657956d4c2d68326f3af1be6a82c77ea51f751a10f3505df418b35c3ccaad0a5"
    sha256 cellar: :any,                 ventura:        "25741aeffea74a1166982f93b60cc2b57c4fd84225ac96f66c079669c6307c56"
    sha256 cellar: :any,                 monterey:       "3e9816ee9c6031d3d834b83864f097530326575c55e712f95085e3ef87982c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32ca42e3523231b38e1b7468562df5af902360fc2f1ed6ced6e99cd0474824b5"
  end

  depends_on "jq"
  depends_on "libyaml"
  depends_on "python@3.12"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3c/c0/031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9/argcomplete-3.2.3.tar.gz"
    sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/7d/49/4c0764898ee67618996148bdba4534a422c5e698b4dbf4001f7c6f930797/tomlkit-0.12.4.tar.gz"
    sha256 "7ca1cfc12232806517a8515047ba66a19369e71edf2439d0f5824f91032b6cc3"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
    %w[yq xq tomlq].each do |script|
      generate_completions_from_executable(libexec/"bin/register-python-argcomplete", script,
                                           shell_parameter_format: :arg)
    end
  end

  test do
    input = <<~EOS
      foo:
       bar: 1
       baz: {bat: 3}
    EOS
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
