class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/6e/19/62010365c0694f801a878b4d0ace6b638312241228b6731f4dddd1c16c8c/glances-4.0.7.tar.gz"
  sha256 "f476e86552da231799bd36e6e7e86e3463eb00505267181f6595c8a4125068f9"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "118e07126f278b830713ebe7d56f44289da308b9ae6a7b75be31110b1160dea3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b093194a8b2a85eab4802e9d8c16019d80c1610a6eb7a29661c253f5f2fb19e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cf078e542bbd4d5f49d6f7294da5257bcd4401e63f2bf9931bd0265bc57a94e"
    sha256 cellar: :any_skip_relocation, sonoma:         "08e983ab1c30dec7559ab844703fefc809649ed94cdce5c490924c3ecca3837f"
    sha256 cellar: :any_skip_relocation, ventura:        "4b8f7a4e09a06a899471ab6b468de45d3050d92abb13424e49a3bf6ee412e10c"
    sha256 cellar: :any_skip_relocation, monterey:       "5e4d3130825cdd64913dc387b7be66b7468d2f2c4070aa69773efe6fe60695d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d72ba378dd7810b23684e0301fe73bc0a53b3286a80dbb5264efb4591d2926f"
  end

  depends_on "python@3.12"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/f0/00/3110fd566786bfa542adb7932d62035e0c0ef662a8ff6544b6643b3d6fd7/ujson-5.10.0.tar.gz"
    sha256 "b3cd8f3c5d8c7738257f1018880444f7b7d9b66232c64649f562d7ba86ad4bc1"
  end

  def install
    virtualenv_install_with_resources

    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end
