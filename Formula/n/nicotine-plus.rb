class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/63/1c/73f765da20b5b7e3579f6099490a9c4ac93e7c6341f97cf51d53ea0df49f/nicotine_plus-3.3.4.tar.gz"
  sha256 "512bf4aea9b42d5f3d58e0c96ed90efc2af568f8d0a624bf957ffb5f84ab9b7c"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, ventura:        "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, monterey:       "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58e9496311f34a6aef3fd0c127a9b8aff7ea59ef0d4f1511e3a00bb999ed8913"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python-gdbm@3.12"
  depends_on "python@3.12"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # nicotine is a GUI app
    assert_match version.to_s, shell_output("#{bin}/nicotine --version")
  end
end
