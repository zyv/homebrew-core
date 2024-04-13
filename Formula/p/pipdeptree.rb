class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/13/be/9657566aded670ba77767dde54ab8b4f19bd8290cddfde92d4f791c35a96/pipdeptree-2.18.1.tar.gz"
  sha256 "cb6cacc5434dc04811bdc91d659622689107e60a163b79a5758e593577fdb875"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0937440920a547197de20ae5179049c3f18b039aecb9102d3fc2b66bfc635c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0937440920a547197de20ae5179049c3f18b039aecb9102d3fc2b66bfc635c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0937440920a547197de20ae5179049c3f18b039aecb9102d3fc2b66bfc635c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5282da0c620d1550d4ccafd9a35629265d40077f304d157100e8dcaa0bfeeca2"
    sha256 cellar: :any_skip_relocation, ventura:        "5282da0c620d1550d4ccafd9a35629265d40077f304d157100e8dcaa0bfeeca2"
    sha256 cellar: :any_skip_relocation, monterey:       "5282da0c620d1550d4ccafd9a35629265d40077f304d157100e8dcaa0bfeeca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c67d06697596b38a86fa1100bb12c2b6290cdd33c09be8e1eff46d0ed9c67f90"
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
