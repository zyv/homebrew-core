class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/28/4b/7cfa0adf9732d7a76749117f06e1a70a7ee8c1c82eb2f8edd5030b249f25/pipdeptree-2.18.0.tar.gz"
  sha256 "205f1e30d230de300338b04422621499cc8b4b8e3ec6de2a27c1864077604c32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a2c099b7b4affc52c09a7dccc53b3177b099468c3744c0049fa387408dcb064"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a2c099b7b4affc52c09a7dccc53b3177b099468c3744c0049fa387408dcb064"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a2c099b7b4affc52c09a7dccc53b3177b099468c3744c0049fa387408dcb064"
    sha256 cellar: :any_skip_relocation, sonoma:         "369ee1db75bd7bfb9e06184fd82e89f98ec55203fb2a52b3158142078b1c9398"
    sha256 cellar: :any_skip_relocation, ventura:        "369ee1db75bd7bfb9e06184fd82e89f98ec55203fb2a52b3158142078b1c9398"
    sha256 cellar: :any_skip_relocation, monterey:       "369ee1db75bd7bfb9e06184fd82e89f98ec55203fb2a52b3158142078b1c9398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d39e30fd969176866761a418e30574d78283b748e4a72cd8b9c1a801ba890b"
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
