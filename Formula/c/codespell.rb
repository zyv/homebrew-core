class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/a0/a9/98353dfc7afcdf18cffd2dd3e959a25eaaf2728cf450caa59af89648a8e4/codespell-2.3.0.tar.gz"
  sha256 "360c7d10f75e65f67bad720af7007e1060a5d395670ec11a7ed1fed9dd17471f"
  license "GPL-2.0-only"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56f15d39c3a8a94ae1e97b2ac5bcf319a7599ffc31513276b5cfefc900342266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e7bf4d7de602e111662c378d93220fe9407b127020f21c5bee0b9121fcd9d38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8951acd26d4fd939043bf67c27cd905fe714852851cd64d5986ea98bd9b48cca"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a8dcc35f274a23a166a14f9d9822095b29be5d5af9a51c9a9d8ac8b2ee6b9a7"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3d3e3655da690c4a4c0e3b314a7590031d280abf8dfd86a2ab813000662a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "075ef1d096144f751fda548a2c12b3e24f83b29370d7b5f4085fa7c0191d1eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab6f78d63a1c9759ad658c8bf95ac5b2977eda4e4aeb5c335c86c73c1187930"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
