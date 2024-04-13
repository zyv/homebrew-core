class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
  sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2a1bfedc5b78b7be43736464d0a1160fde2e25075d0ce375e03e421de6dd25d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2a1bfedc5b78b7be43736464d0a1160fde2e25075d0ce375e03e421de6dd25d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2a1bfedc5b78b7be43736464d0a1160fde2e25075d0ce375e03e421de6dd25d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d146e4b2a1f6577848b6b5ff2d181a3caa0cafee53c42bfa8bd307aecc083ede"
    sha256 cellar: :any_skip_relocation, ventura:        "d146e4b2a1f6577848b6b5ff2d181a3caa0cafee53c42bfa8bd307aecc083ede"
    sha256 cellar: :any_skip_relocation, monterey:       "d146e4b2a1f6577848b6b5ff2d181a3caa0cafee53c42bfa8bd307aecc083ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2a1bfedc5b78b7be43736464d0a1160fde2e25075d0ce375e03e421de6dd25d"
  end

  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end
