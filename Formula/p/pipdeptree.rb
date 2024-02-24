class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/a1/eb/2b71b63917845b231fe150ff70ef2f10c856a20d721c081a115e87cba2fb/pipdeptree-2.15.0.tar.gz"
  sha256 "b80098c9337f27b1d612c35223aa5a655c9a9e32021d7d0d0091e8dbce78fbeb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b61c7f2e42bbac735ca60dda48dd3d1714db6ef4ec7308a0749e478bfb8969ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c58beaef91e51d7becd9ddfa4d9c6dacaf8f0881a24bd2c62a707bc491fee4ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21ef70e594213d0917be474d881a4f55072b1e474be4c5678369641ea1570a00"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fb2ba787ea3f581e3cee70578f4850f040e59512afc51509fa80541461f8147"
    sha256 cellar: :any_skip_relocation, ventura:        "51b10feb74cff4461ffc222a7f478f248793422ba77bbd447c9020c70eb37f12"
    sha256 cellar: :any_skip_relocation, monterey:       "f153dae1c82875153ee15e68ad4bed1f0a534c0fce24f86811b8c0f4c344671b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8e9ccce3b965c3b1f3cb55609f25db902a8d3fddfb1ae49e74a8b52c521fe05"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
