class PythonPycurl < Formula
  desc "Python Interface To libcurl"
  homepage "http://pycurl.io/"
  url "https://files.pythonhosted.org/packages/c9/5a/e68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72/pycurl-7.45.3.tar.gz"
  sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  license any_of: ["LGPL-2.1-or-later", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ac515c6b2154b523a86de9a6ee580ade298c825bd735c73eb922857bc8fe04a3"
    sha256 cellar: :any,                 arm64_ventura:  "f42e236a9c6a848a8a9b6fab97c245a2070f14bc46c004beb693c8a0b6fd0e8f"
    sha256 cellar: :any,                 arm64_monterey: "48893fdcbb66ff23eb72049784a568e52a3452348ab19d5563a3f6b2bf0bfbb2"
    sha256 cellar: :any,                 sonoma:         "7fb9a02d61098ddd50349f8a3ac4729e01b4c95bad8870faa38a295eabf99d45"
    sha256 cellar: :any,                 ventura:        "aee44a44793eb38112a643cdcdeb77fc004819cb8b068121f4c5ff85b144e965"
    sha256 cellar: :any,                 monterey:       "d7cdf45e7ee9f65eefadbd9efafd0499e8c973c2931a7b07058f0fb133ff3eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c9ed88f96d7fa65a7f6b287d3313824bd73a5910b4f8613304deb6bcdd95c39"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "curl"
  depends_on "openldap"
  depends_on "openssl@3"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import pycurl"
    end
  end
end
