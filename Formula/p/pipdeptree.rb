class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/9d/3a/cded13c8690905c592bc8f39ac4d8d03e26caf3b27cdf0d5f26ae4051de3/pipdeptree-2.16.1.tar.gz"
  sha256 "f1ca64ce4aff9373613711048b9c4e8106ad955dea0dd962b7974fa168d7650a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c22b82d0928fa31cbc9b67f4afd09941eb65f9620a685e521525bd83be4deff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eac12bee0099238b606ad219eef675657000c207644519b1f57e2fafdfd6d061"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcc7cc38066455b5db186b7683383282c7fa12d2bbfec9319fa8d034aadc41da"
    sha256 cellar: :any_skip_relocation, sonoma:         "829e5994a653a80749d1fe5fe8f13b3ab8e1784542c79fa99b7202e541f4dc31"
    sha256 cellar: :any_skip_relocation, ventura:        "d170aed20f752025ac2986bc578ff8625603f151d2c5099fffcdaa00cf29517f"
    sha256 cellar: :any_skip_relocation, monterey:       "12a2790e57ea2602af2b46f7ea760c4fb087f1498a83d6738873145a8e396549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ce9e819a55f43060d24dc9f4ed59f61c192f11cf37df4416bf1acb49ecf08d"
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
