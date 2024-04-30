class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/27/23/57d2d0a002a77638c2f3196d24d966209f51c498413ac1758d1680a0f96a/urlscan-1.0.2.tar.gz"
  sha256 "d909ff180588008faba8a6491e3e0821ad3c8a3b6574b94fd73b8fb11ff302f2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58abd0961d6cd3c5dfb45e0bb665573fc3d819e75ce824225f575e5584069b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f3ac327ced320306b628a196e5feec94ab2202742bb785e620517cc06cdac61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44fb892524f6ec60ca56da2887e428211a562ed0a021f728d730949571cd25e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "696105412b5246d755f08720c2c733dc320878ec0a92101f2c1906cf36ba28b8"
    sha256 cellar: :any_skip_relocation, ventura:        "e5354052fd940bbe2705ec05e00311d265ae406986cbbfedd4c41c0980e6c995"
    sha256 cellar: :any_skip_relocation, monterey:       "23e9cb821b7601fb8c211b5e17d85ae10e62ba445b8bbc9cde76641375f6338b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1303d4b8e115058fe993501876848d9e7fa28c09e0208f387f674dd11a6ecd5"
  end

  depends_on "python@3.12"

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/ef/fd/77d351caa11c438c7536bba12ea26bb1f22fe7fd0d9aa65849d4625c3e2d/urwid-2.6.11.tar.gz"
    sha256 "52770007d734d7387ae0421e7b7769c4c5ec67e91a5f4df54e858e314062e475"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    man1.install "urlscan.1"
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end
