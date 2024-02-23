class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc43a81dcd0224e032355f7ea81dd6de635ddd47b0b825976b89c279fde6ffb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbe4c48d4bc66d2320979367b7278755f56be8d5eac7e2f3b35d5d3d520f3a63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb5dc631d29d93f8b0f129397af31130c191a999817c313d0ebd346e3918b602"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb4ebfb14b2f20cc6da9c45ba8c34150b5d827b49c1d8201802d77a472464908"
    sha256 cellar: :any_skip_relocation, ventura:        "a57584e6b7b87bcbcabd58e7940d12ccf5190bdb02aa3603d76768106fe93180"
    sha256 cellar: :any_skip_relocation, monterey:       "0c089e77f856a538eee4a3b282eb30906ed2590825a8c03655994ea500d7e07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b962c0ce56c2662067b53e2b40b8499b4cda28011790acbd4fb18a17576030"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/11/28/c5441a6642681d92de56063fa7984df56f783d3f1eba518dc3e7a253b606/Markdown-3.5.2.tar.gz"
    sha256 "e1ac7b3dc550ee80e602e71c1d168002f062e49f1b11e26a36264dafd4df2ef8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<~EOS
      # Header 1
      ## Header 2
      ### Header 3
    EOS
    system "#{bin}/mdv", "#{testpath}/test.md"
  end
end
