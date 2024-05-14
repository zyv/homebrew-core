class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/62/75/e48496ea7fc2de24b361dd8084300a2f7e51c47e82363c736026d41cdf2f/pylint-3.2.0.tar.gz"
  sha256 "ad8baf17c8ea5502f23ae38d7c1b7ec78bd865ce34af9a0b986282e2611a8ff2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72e516f8f9ad556ef7d3d6984ecadb90beb35667163b94807ed0b3a7496eb78e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f419e4b9abb5d94be98d13770234e8b61f32032cd13b78ef25d4d89c53e53ae7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada341e3d036ed98d6558c16e9030fef3409e7967d8beae8836c67929cef2e57"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eef1b6936882ef656f0c430e13c0a4043e141e24b6b6259f2beccfbbbf9d204"
    sha256 cellar: :any_skip_relocation, ventura:        "2584a39bee2d4dee2ec05932a2d46416130240aad346f8d1de1dac4017301186"
    sha256 cellar: :any_skip_relocation, monterey:       "97382be31c7d1560cd1253cbf21f4174a6a13f3b20000b00215f423c06ceee9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15cb0989a8b4bd186cebbda6f058b0dacd13694200e12ee0a9529cfb6506d3a1"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/b6/e8/f86aa1fd91b7fa5b51ed53c9a06a94dba7cc388b51cb712e8721c41605ef/astroid-3.2.0.tar.gz"
    sha256 "f7f829f8506ade59f1b3c6c93d8fac5b1ebc721685fa9af23e9794daf1d450a3"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/17/4d/ac7ffa80c69ea1df30a8aa11b3578692a5118e7cd1aa157e3ef73b092d15/dill-0.3.8.tar.gz"
    sha256 "3ebe3c479ad625c4553aca177444d89b486b1d84982eeacded644afc0cf797ca"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/87/f9/c1eb8635a24e87ade2efce21e3ce8cd6b8630bb685ddc9cdaca1349b2eb5/isort-5.13.2.tar.gz"
    sha256 "48fdfcb9face5d58a4f6dde2e72a1fb8dcaf8ab26f95ab49fab84c2ddefb0109"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b2/e4/2856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937/platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/2b/ab/18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8/tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
