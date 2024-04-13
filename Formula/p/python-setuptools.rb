class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/76/6c/a1e240d85b63e04b2f6786a39e32ea78ad9ec7a9e8193b5510b63b5add94/setuptools-69.5.0.tar.gz"
  sha256 "8d881f842bfc0e29e93bc98a2e650e8845609adff4d2989ba6c748e67b09d5be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "925c1d73a5fdd47ae39d0e157c096d3f23ddac54908a07771e22e4ac0540ab1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "925c1d73a5fdd47ae39d0e157c096d3f23ddac54908a07771e22e4ac0540ab1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "925c1d73a5fdd47ae39d0e157c096d3f23ddac54908a07771e22e4ac0540ab1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a21365538d499e90b3f0cc9ef3de93b6e81e43d9bf01a47982cbb69bc8bec70"
    sha256 cellar: :any_skip_relocation, ventura:        "3a21365538d499e90b3f0cc9ef3de93b6e81e43d9bf01a47982cbb69bc8bec70"
    sha256 cellar: :any_skip_relocation, monterey:       "3a21365538d499e90b3f0cc9ef3de93b6e81e43d9bf01a47982cbb69bc8bec70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "925c1d73a5fdd47ae39d0e157c096d3f23ddac54908a07771e22e4ac0540ab1d"
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
