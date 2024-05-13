class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/23/ef/99c1531ad5454a560a9ff17789320e68d8d7aaceaa8222b293e3fa7488e8/pylint-3.1.1.tar.gz"
  sha256 "c7c2652bf8099c7fb7a63bc6af5c5f8f7b9d7b392fa1d320cb020e222aff28c2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "613cc04309c111243666073e047c630dc976cd37b4557b833f5514c5a352bb65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a76645179474210d597987cb184b21db1bc477b4faa6631ca95d9a588e8a7d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195cb58b28c39bd0e310fcfa79a2013542d5bea950cf6180ef5660adcbed41f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "046c67d2714573612eb3fc3c4603fd0bc536cc89f432c9d8185b5d8ada07dbd9"
    sha256 cellar: :any_skip_relocation, ventura:        "823a6cb0b92c4a540229ad420415db735bad7d79c0d859c1943bd448626a8fca"
    sha256 cellar: :any_skip_relocation, monterey:       "5bd190ba759c9ba7e38fc180512f8a58884f2ae38b1f6a0ce01372b13ff13f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67cb7c06f0acd095b6b6307ad43d3140ae931b6f0756940ffb57dca938692584"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/a9/b9/f11533eed9b65606fb02f1b0994d8ed0903358bc55a6b9759e42f1134725/astroid-3.1.0.tar.gz"
    sha256 "ac248253bfa4bd924a0de213707e7ebeeb3138abeb48d798784ead1e56d419d4"
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
