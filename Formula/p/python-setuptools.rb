class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/7a/12/dc02a2401dac87cb2d3ea8d3b23eab30db4cd2948d5b048bf912b9fe959a/setuptools-69.4.tar.gz"
  sha256 "659e902e587e77fab8212358f5b03977b5f0d18d4724310d4a093929fee4ca1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48673e50b9474f4e00b998088484ed366e685ec3d34ea52c68557cfe774e7d5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48673e50b9474f4e00b998088484ed366e685ec3d34ea52c68557cfe774e7d5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48673e50b9474f4e00b998088484ed366e685ec3d34ea52c68557cfe774e7d5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c8f16f1ce22479056cd208b11cb64e7071d412941f11689035b9654d065a9c1"
    sha256 cellar: :any_skip_relocation, ventura:        "7c8f16f1ce22479056cd208b11cb64e7071d412941f11689035b9654d065a9c1"
    sha256 cellar: :any_skip_relocation, monterey:       "7c8f16f1ce22479056cd208b11cb64e7071d412941f11689035b9654d065a9c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48673e50b9474f4e00b998088484ed366e685ec3d34ea52c68557cfe774e7d5c"
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
