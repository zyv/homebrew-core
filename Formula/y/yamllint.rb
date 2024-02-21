class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/da/06/d8cee5c3dfd550cc0a466ead8b321138198485d1034130ac1393cc49d63e/yamllint-1.35.1.tar.gz"
  sha256 "7a003809f88324fd2c877734f2d575ee7881dd9043360657cc8049c809eba6cd"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16120f61c559ec5fd83bb28d110b265d7bfeb38fb5f6ae3958b6edddc3836fde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ede8ae30ddc0615758e87836e91d84e712616801d17c0ff0ae1ebb737f4ae7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee60920ab2ac09300844b9a0ddadef8b212d331e77ad00a3a8d163ce4651860a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a9a0bfa4caf102c09649e2c5ef5d8c33da13ffc0390c167ed6b4b35b8715b5f"
    sha256 cellar: :any_skip_relocation, ventura:        "8d1074f726fc3dce640a3c19542edcac8bfd67676508c43879ed833d919a12b1"
    sha256 cellar: :any_skip_relocation, monterey:       "9c609546ff7edd2d308ec5dc3e49676eeab8eda9ef9211571aadeeeeee74920b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8799f333c63d658c4dd6d87113fab523b23b8e41940e869c50e4205609145bb7"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
