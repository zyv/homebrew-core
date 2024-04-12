class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/04/c6/ca9a7d5365c31e3e8442efe4bd24ced6784ca4b8934b00cdc9f537f700f5/dunamai-1.20.0.tar.gz"
  sha256 "c3f1ee64a1e6cc9ebc98adafa944efaccd0db32482d2177e59c1ff6bdf23cd70"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, ventura:        "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da09863b7936aeeb1179f2cac85c3496349a1729b65779cbc952a07f529c146a"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end
