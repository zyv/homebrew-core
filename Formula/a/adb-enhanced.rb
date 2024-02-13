class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/82/11/1228620ea0c9204d6d908d8485005141ab3d71d3db71a152080439fa927d/adb-enhanced-2.5.22.tar.gz"
  sha256 "b829dcb4c9a9422735d416a62820de679bed8b08dfbff2014d46a525c39bc7d0"
  license "Apache-2.0"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "270501b0f07f5c76764995f31d5087e01ba332d0c502ea48eb1a7667252c8fe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28b951d3551788ea09a1023fa2747ce1dca87dae27338a333588f5b642de8e37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50a7a3e27bfb779e210f5b3634e3241d825456de52b8c4a5e07fd39a33c5ec0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e63b32d87f4ae42d22a824b92a77fae7c6175bb4cdec1020bc10a0d7e288340e"
    sha256 cellar: :any_skip_relocation, ventura:        "1f56b440e4049c680867db385d72d8e7b254e3ca66b2f2ab0eb5efd7bd1f0305"
    sha256 cellar: :any_skip_relocation, monterey:       "d78f6ae319faf0fe1a6afe2ee9cce68596fc4176d21147b4f699849d16b92c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8127d39ce29748af15e37457179cb1518d11d5f7e6dcf6f2a6b873f8828dd6f8"
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
