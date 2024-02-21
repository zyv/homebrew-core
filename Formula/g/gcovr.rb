class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/a5/d9/fc88c9df718e44dad943fec14db80e49cc0b1a592bbbf691f56a3955ccaf/gcovr-7.0.tar.gz"
  sha256 "d4124f89e9299cce4a0b2fda9b9cd6c07c4b7d0e94705eb071fd332671ee1125"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ba967b39d66a607fd70e1e2c8e95d2e8dc1a33477cb3b2a4e6598e6f7a701fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c941061471aaa43a9fa8d62f10be4eb7040c40e6a5257983f4e7377b4536dd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5af5ceb4586081bf0f010ceb7b7a2c6c9484b768b971494a3f1a0cd2d083960"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f92f46be61fa75c18cc494f8af9b4ca0838e9c49ee5e3e20fa6abe56d27186b"
    sha256 cellar: :any_skip_relocation, ventura:        "01012e3cff3e45509a0b98123f00bbda12395bb6db5b6da77d0dc9d8bcd79d06"
    sha256 cellar: :any_skip_relocation, monterey:       "3a7c3de3406ab3b3b55664cadd809c9eafb4d1e538ae45664c83d9e74a8e05ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d4fe2eee6e597b885839701d147fcea5695ea45868046c5579922715bfce245"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system ENV.cc, "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                   "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end
