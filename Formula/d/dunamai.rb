class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/e0/84/e321b67334207eefeda01942cd57c93ed985e2a4b5e1af1cd60458d7d0d0/dunamai-1.21.1.tar.gz"
  sha256 "d7fea28ad2faf20a6ca5ec121e5c68e55eec6b8ada23d9c387e4e7a574cc559f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, ventura:        "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, monterey:       "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed0cde65c325304435d77baca42ac3d18dbe0e7ff7a6152a17f13a30bceee4e"
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
