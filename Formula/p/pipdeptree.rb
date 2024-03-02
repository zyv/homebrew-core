class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/47/ef/6f1f8d9ae9c605ac5e0e6bbfcaa8e0d1efb3ba2ac726c971f169c52c5330/pipdeptree-2.16.0.tar.gz"
  sha256 "45b045a539a87dde690596f4293ac7af7c6a1cd0a3480b06de9d33046564d17b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f0565d189ab862865633467723550c1ccff44aa8d4235bd48064861e981b2c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18cd47f1467526611437ffa692e4657cf3eca8647f2df33b393d6d90c54d6fee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2bc2c7eb1b8e5f9c86a43e458d6338a6afe0159cf4a867f850b201a0f7b8fd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5829e9dfe7f4483b91424a019eb114620568a666fbf351708a2a741e3631e30e"
    sha256 cellar: :any_skip_relocation, ventura:        "41961bbc63f1b75ed829a7bf1b53e629ebe47c303c1346aeead8ac59942f58ad"
    sha256 cellar: :any_skip_relocation, monterey:       "d18de5c5a366733be8ef30a3d4ea61369be28f3952d9460517d8c29ab930d482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cd0dbf09ca3ed953c07500d2a4338bfb12d83aa593de5f30acc5c23f7c34d22"
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
