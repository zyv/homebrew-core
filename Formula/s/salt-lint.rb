class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/e5/e9/4df64ca147c084ca1cdbea9210549758d07f4ed94ac37d1cd1c99288ef5c/salt-lint-0.9.2.tar.gz"
  sha256 "7f74e682e7fd78722a6d391ea8edc9fc795113ecfd40657d68057d404ee7be8e"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d2cdc09e20b05ef45c8ea7525a357450ebdf867e3813f62cd18ce07f85b720d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a10c7a245f037a496a25389c10f66d86e92b822ee582f50fe9f27890f5609aae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e09050c5903ca1b96df6c3d2ce065f1db084f719582648af9daba3afa8c80e4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "71c604bf31211c265da05e71f0a42966bb014e303042012a959683c71edc9eaa"
    sha256 cellar: :any_skip_relocation, ventura:        "42effd243df6229f09bec381d5b1173961f7405df5de9381fe85035561a5aae7"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf071bdf7391d71463ae6dc94f99535ee1c63c5fb5ffd7785102b20bc7809cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c078eb6a20855ba5acd4eab424ce00a363abafe2f257f0b9fc8e270ca9b0fa3"
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
    (testpath/"test.sls").write <<~EOS
      /tmp/testfile:
        file.managed:
            - source: salt://{{unspaced_var}}/example
    EOS
    out = shell_output("#{bin}/salt-lint #{testpath}/test.sls", 2)
    assert_match "[206] Jinja variables should have spaces before and after: '{{ var_name }}'", out
  end
end
