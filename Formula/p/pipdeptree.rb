class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/e5/8d/c506de2d472182ab89e58f3d6e2d2843a2e6242adb4d1b10289e645cb9ac/pipdeptree-2.17.0.tar.gz"
  sha256 "f2c19758c023bca0c08fa085ced2660cff066a108a792b1a72af5b5344c47ae0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f8ab079473679c1a0efa884091f9e278c427fcf1eddced097480fbe266cd112"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f8ab079473679c1a0efa884091f9e278c427fcf1eddced097480fbe266cd112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f8ab079473679c1a0efa884091f9e278c427fcf1eddced097480fbe266cd112"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbd67fdc0e38e2ce7e70f7a53c5def58238e12ea7e2296b413cb62d3b80fd27a"
    sha256 cellar: :any_skip_relocation, ventura:        "cbd67fdc0e38e2ce7e70f7a53c5def58238e12ea7e2296b413cb62d3b80fd27a"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd67fdc0e38e2ce7e70f7a53c5def58238e12ea7e2296b413cb62d3b80fd27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a795130ee233c5e675fcd22bcc6009167d56945dd00d01a5cda9206fc6a529a0"
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
