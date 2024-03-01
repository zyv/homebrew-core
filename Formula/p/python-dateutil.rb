class PythonDateutil < Formula
  desc "Useful extensions to the standard Python datetime features"
  homepage "https://github.com/dateutil/dateutil"
  url "https://files.pythonhosted.org/packages/d9/77/bd458a2e387e98f71de86dcc2ca2cab64489736004c80bc12b70da8b5488/python-dateutil-2.9.0.tar.gz"
  sha256 "78e73e19c63f5b20ffa567001531680d939dc042bf7850431877645523c66709"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb7e7a8095b6ef0faa231cb385e2edf152f93bd8b6b201f8f0283975aa8a0c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9e043c7c21453f6613a65aae1b44a61ced3a69cf4152e6a83374d0b483acc96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a45eb0c21908f79df8445fcef22c6b90d59c22d69d5e89679138a778623e1862"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca7324974470db0fb253c16f2a66c8131071a064425b3ea59e88b55111f10c76"
    sha256 cellar: :any_skip_relocation, ventura:        "634ed37fc5639de61617a6a5b373801057bf2ab3a6b0e373997dd77cce60c5bd"
    sha256 cellar: :any_skip_relocation, monterey:       "7b8d9a4e6d6e0c13b7d3d2c599fc10eb55d9edbb27d45dbd3a6ffb226b2cc114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5cddb58045c1b708645154c609bf0e1f2bdc1634a12d933e072417a99681456"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "six"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
      system python_exe, "-c", "import dateutil"
    end
  end
end
