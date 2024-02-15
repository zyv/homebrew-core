class PythonMatplotlib < Formula
  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https://matplotlib.org/"
  url "https://files.pythonhosted.org/packages/9a/aa/607a121331d5323b164f1c0696016ccc9d956a256771c4d91e311a302f13/matplotlib-3.8.3.tar.gz"
  sha256 "7b416239e9ae38be54b028abbf9048aff5054a9aba5416bef0bd17f9162ce161"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f87a007e183b78fa45896bac75b13b200578b4c6f6050936276aa96124bbf9f1"
    sha256 cellar: :any,                 arm64_ventura:  "ee20b0c03a2e716a921094c99cf80389bf93a420239d240fa510e2e889ba9806"
    sha256 cellar: :any,                 arm64_monterey: "6e2e71a8fbbe29b1ab69bfb55db81fdd54df60ae3daede8f68602cd9cb28dc6d"
    sha256 cellar: :any,                 sonoma:         "93462a6519a47d5a5081757e8789b4db91d558ef75aa5e770cb0d4a0f04ef35e"
    sha256 cellar: :any,                 ventura:        "bbc45a72ffecf6b32dd83f9f11d8409a377f84b872b5810093e9ed42f759bbba"
    sha256 cellar: :any,                 monterey:       "7695df8adadd3e9d16acfaae8b187535ea64fb966abd17abe804d9e72b1993a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5c3878e5809e6b57c432f52deb5717c465be6715e400837aa770f9e32e432e"
  end

  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pybind11" => :build
  depends_on "python-certifi" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "fonttools"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python-cycler"
  depends_on "python-dateutil"
  depends_on "python-kiwisolver"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "qhull"
  depends_on "six"

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :gcc do
    version "6"
    cause "Requires C++17 compiler"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/11/a3/48ddc7ae832b000952cf4be64452381d150a41a2299c2eb19237168528d1/contourpy-1.2.0.tar.gz"
    sha256 "171f311cb758de7da13fc53af221ae47a5877be5a0843a9fe150818c51ed276a"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/24/d5/c9e4706b3f564d8afe3005ccea1c9727a631efe790f8bb17819d12b192ec/fonttools-4.48.1.tar.gz"
    sha256 "8b8a45254218679c7f1127812761e7854ed5c8e34349aebf581e8c9204e7495a"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/b9/2d/226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85ea/kiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/65/6e/09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058/numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/f8/3e/32cbd0129a28686621434cbf17bb64bf1458bfb838f1f668262fefce145c/pillow-10.2.0.tar.gz"
    sha256 "e87f0b2c78157e12d7686b27d63c070fd65d994e8ddae6f328e0dcf4a0cd007e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def python3
    which("python3.12")
  end

  def install
    resource("contourpy").stage do
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end

    (buildpath/"mplsetup.cfg").write <<~EOS
      [libs]
      system_freetype = true
      system_qhull = true
    EOS

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    backend = shell_output("#{python3} -c 'import matplotlib; print(matplotlib.get_backend())'").chomp
    assert_equal OS.mac? ? "MacOSX" : "agg", backend
  end
end
