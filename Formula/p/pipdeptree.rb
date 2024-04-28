class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/9d/db/b72e65032bbf4b5b2e4c2efae7fd7fae5eeb879b582c1d34a7efe05401c5/pipdeptree-2.19.0.tar.gz"
  sha256 "2051bc730fa878846ff3184c1b6b83d348f606cd1a92b9afca9709334d3d0c03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0a3c03edb5836c997b63261382581d70698be571bdba6ecdd3471eb5d214c30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a3c03edb5836c997b63261382581d70698be571bdba6ecdd3471eb5d214c30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0a3c03edb5836c997b63261382581d70698be571bdba6ecdd3471eb5d214c30"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1e4281220730067a83659cd3c7566b1a7931fa8c3d39e4974c828ca59b9771f"
    sha256 cellar: :any_skip_relocation, ventura:        "b1e4281220730067a83659cd3c7566b1a7931fa8c3d39e4974c828ca59b9771f"
    sha256 cellar: :any_skip_relocation, monterey:       "b1e4281220730067a83659cd3c7566b1a7931fa8c3d39e4974c828ca59b9771f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83aab7daf65a2dfe49a588b04c4887e5a1add8c6dc270423d5cbd8aedbd29460"
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
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
