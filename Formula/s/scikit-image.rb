class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/4b/12/2337d523dc7085ef0e5a51dfde6059e7969442919aeac8de0064bdb8adb7/scikit_image-0.23.1.tar.gz"
  sha256 "4ff756161821568ed56523f1c4ab9094962ba79e817a9a8e818d9f51d223d669"
  license "BSD-3-Clause"
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4afa8bc6b806407f20bdea39787f6a5ad3d65e518e3a1b938a25c872f6dd7d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c16471edcf50b0668540e00ddf99c94462c462593695905e69aeda14a28df3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b2631b6289770d65f2510cf6f3d48f2970669cb7cc8aa8fe0b407f961a8c1fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "57d55f35201883265c04e4d6d5f1684bd03530f3c779c67b329a62ef525aebdb"
    sha256 cellar: :any_skip_relocation, ventura:        "d3688bbcc6f0ec604680f9696c35f3b58ceea6d164b3cf398f2340d264f1284a"
    sha256 cellar: :any_skip_relocation, monterey:       "0d2c5579cdf063ebab64f60a31a62ed1736b101f872bad3b262aada481598d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b624260b5446414ea7aa0947875f1cf98b2cf49df292e8d7fc61115c58f61e85"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "scipy"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/c3/71/70f81a9c0cd3b106f6663af8d92402d16354abec48f7b8ba15a6c41ddca9/imageio-2.34.0.tar.gz"
    sha256 "ae9732e10acf807a22c389aef193f42215718e16bd06eed0c5bb57e1034a4d53"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/6f/6b/c875b30a1ba490860c93da4cabf479e03f584eba06fe5963f6f6644653d8/lazy_loader-0.4.tar.gz"
    sha256 "47c75182589b91a4e1a85a136c074285a5ad4d9f39c63e0d7fb76391c4574cd1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/04/e6/b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ec/networkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/d1/54/e627e6604700d5ec694b023ae971a5493560452fe062d057dba1db23ac82/tifffile-2024.2.12.tar.gz"
    sha256 "4920a3ec8e8e003e673d3c6531863c99eedd570d1b8b7e141c072ed78ff8030d"
  end

  def install
    virtualenv_install_with_resources
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/skimage/**/*.pyc"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      import skimage as ski
      import numpy

      cat = ski.data.chelsea()
      assert isinstance(cat, numpy.ndarray)
      assert cat.shape == (300, 451, 3)
    EOS
    shell_output("#{libexec}/bin/python test.py")
  end
end
