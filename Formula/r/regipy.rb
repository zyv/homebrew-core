class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/e0/f2/61846ba036f840b3cfe9b412dca3ef629bdc7506faafbd56b2c8de987950/regipy-3.1.6.tar.gz"
  sha256 "edc9fd8501f3374afd49020550bf361235e569959712825fbd2f444d2aeca8d9"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c228285dae25a3651e6baba502a522837c8d2cc1076d6adaca7f8fc806a731c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41d0c06d9a4f35b4d6c2a90fe484940c92f564316cc5672a5d14dff0486f349b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b89c5207e8037065d74c6df55dd63633063ea4a039190901643bb44ab8858bba"
    sha256 cellar: :any_skip_relocation, sonoma:         "efa3c9158dedf6675c04ef54dd3126d57a35b4ad89c518d8be70cfb2df6bbda2"
    sha256 cellar: :any_skip_relocation, ventura:        "e94c00ab84ebed8cd117f98da53b6cace219a3e422af0ea7b8433d9d3102d85e"
    sha256 cellar: :any_skip_relocation, monterey:       "022f206299aebaa2f8319f3e040d91ce64094051939b61a2cc5acf02fcb3c4d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03872c4afcca0055fe5457ccdc5f87cc3eec37a3691af6f7e7b73b1e46e26017"
  end

  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/02/77/8c84b98eca70d245a2a956452f21d57930d22ab88cbeed9290ca630cf03f/construct-2.10.70.tar.gz"
    sha256 "4d2472f9684731e58cc9c56c463be63baa1447d674e0d66aeb5627b22f512c29"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test_hive" do
      url "https://raw.githubusercontent.com/mkorman90/regipy/71acd6a65bdee11ff776dbd44870adad4632404c/regipy_tests/data/SYSTEM.xz"
      sha256 "b1582ab413f089e746da0528c2394f077d6f53dd4e68b877ffb2667bd027b0b0"
    end

    resource("homebrew-test_hive").stage do
      system bin/"registry-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
      h = JSON.parse(File.read("out.json"))
      assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
      assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
    end
  end
end
