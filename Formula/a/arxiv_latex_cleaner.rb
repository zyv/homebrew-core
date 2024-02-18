class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/66/87/8866fcffec4c6d39eaa7a08e3bb0b98ec98464aef55fcf0897196819a2f0/arxiv_latex_cleaner-1.0.4.tar.gz"
  sha256 "6c371dd6c7bec01259bebc80820e6704274d2f5f75f9de1d112d9d3f8a392023"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9926ba1519bb1933b5b3e55eee8da2ee792622f746f847c9b8580500082ac7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f10455191a84966aad3b801b79fbcfa2bf84b64a33df7c4dd94a769360c93e90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80a7439b69ba7d7e17f7dae540ab787f87685b79441cb2415718ba71f9672c85"
    sha256 cellar: :any_skip_relocation, sonoma:         "7200ba3398e0583f2217e5d71b6baa45a12e136e0a54eda00a48ae5df911edee"
    sha256 cellar: :any_skip_relocation, ventura:        "2c7f73905c4cbb6ccce97b3bcbbad77d776e0e4a3e566742add8be40e7489e39"
    sha256 cellar: :any_skip_relocation, monterey:       "c1f6514d247699003db517b34a549334f581138ad4f7890024bac3d733f65ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848d878cb7be53a4cb28b29faf3d79af0d9698aa43d2073d1af1ba2fb83691ed"
  end

  depends_on "pillow"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/7a/8f/fc001b92ecc467cc32ab38398bd0bfb45df46e7523bf33c2ad22a505f06e/absl-py-2.1.0.tar.gz"
    sha256 "7820790efbb316739cde8b4e19357243fc3608a152024288513dd968d7d959ff"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~EOS
      % remove
      keep
    EOS
    system bin/"arxiv_latex_cleaner", latexdir
    assert_predicate testpath/"latex_arXiv", :exist?
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
