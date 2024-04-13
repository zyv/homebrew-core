class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/76/6c/a1e240d85b63e04b2f6786a39e32ea78ad9ec7a9e8193b5510b63b5add94/setuptools-69.5.0.tar.gz"
  sha256 "8d881f842bfc0e29e93bc98a2e650e8845609adff4d2989ba6c748e67b09d5be"
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
