class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/93/9f/97beb3dd55a764ac9776c489be4955380695e8d7a6987304e58778ac747d/virtualenv-20.26.1.tar.gz"
  sha256 "604bfdceaeece392802e6ae48e69cec49168b9c5f4a44e483963f9242eb0e78b"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfe01d126afa05023ab76ca58698f174a8499fc3e07b38796b3ddcc71fabcb2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfe01d126afa05023ab76ca58698f174a8499fc3e07b38796b3ddcc71fabcb2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfe01d126afa05023ab76ca58698f174a8499fc3e07b38796b3ddcc71fabcb2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "89344d38f45eb8e75a560f0810a34616c4e3dcfa04c12ee64ec11933f85be21f"
    sha256 cellar: :any_skip_relocation, ventura:        "89344d38f45eb8e75a560f0810a34616c4e3dcfa04c12ee64ec11933f85be21f"
    sha256 cellar: :any_skip_relocation, monterey:       "89344d38f45eb8e75a560f0810a34616c4e3dcfa04c12ee64ec11933f85be21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5463b74953eb67be500e6d08fe9a43a79a1413fe670ac57208c055d51d820576"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/06/ae/f8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897ea/filelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b2/e4/2856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937/platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
