class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/dc/9a/8a0921ed2df4da26197f98b0f6a8b3af1fa232cc898a13e719e9ed396e95/archey4-4.14.3.0.tar.gz"
  sha256 "31ce86c6642becd11a9879a63557ed5cef3f552cd9cfe798299414a9c5745056"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2fda1d85c43e769d8e76074a379251c2ce852f3c80c40995250018fb09b083a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e8069e7847887ccc012472a2195ccd2b5f013da79a728981af9393439cff3b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b945fa5bd63c3ade3a8f75aafe4a7a10710299b19c142167da603e24a6c87fea"
    sha256 cellar: :any_skip_relocation, sonoma:         "dee1c6ed8e230f1b32bd7e4c0a81519a109653a0f9fd0a0121f13fda2c5e1dbc"
    sha256 cellar: :any_skip_relocation, ventura:        "ed18454fece28e67caefb5188fe0ac2924d9a75f2aed23eae00900fed694f4d9"
    sha256 cellar: :any_skip_relocation, monterey:       "19e4e3528875765e5d7df6d5f24fa12c1df66baac1a9dd015caeea756e7e08ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b65d6505774745b695b3797f978e68822395316aa0d053ac5157aee461cff7"
  end

  depends_on "python@3.12"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/archey -v"))
    assert_match(/BSD|Linux|macOS/i, shell_output("#{bin}/archey -j"))
  end
end
