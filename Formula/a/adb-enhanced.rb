class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/8d/7d/baff371b8795aec480c607b08473502dde2dcaf4b887f22aa30c42979293/adb-enhanced-2.5.24.tar.gz"
  sha256 "1b26a774bb6de61910f9cc53cd1b6ff5480d4d69cc07dd9768712f316263920d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51a67bb55d0e87a80e019ebd83aa0727d4b36b120c76c418c682b8be86581eac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17587c28965d771742ff5534845bf2baf68e778c86a9d718fc6c02b4fe294ce6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "721b9860f8be251a1f596fe981018e2692134af5dcf5d24338ef44201d2280ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ca4773ccb54dd5db5f97116825683419d8eb95f54ba9bd4dcb4f41f3ad29580"
    sha256 cellar: :any_skip_relocation, ventura:        "6677398363342be5b9f19ec3dcde7c3d18b60960cf646a552caec994bf34906e"
    sha256 cellar: :any_skip_relocation, monterey:       "2fa6699de13ac4dd8494f4140c989bf125466062d1ada85fb95f779fb4368095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dd75d2003096b929ed0531d0b657805a7f251e831b5e2d8042ce1b2b47a41ad"
  end

  depends_on "python@3.12"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match(/(not found)|(No attached Android device found)/, shell_output("#{bin}/adbe devices", 1))
  end
end
