class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/7a/a9/0edfeed967a09781f7f15ab347a57467cc12341afdde3785474f0c6129bc/pylint-3.0.4.tar.gz"
  sha256 "d73b70b3fff8f3fbdcb49a209b9c7d71d8090c138d61d576d1895e152cb392b3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0394d9ab0c13809fc0bfa343b2a520d01decfd3630241b35ee0e112984c0111"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f62cfef4d1142f681f0229d259586aebf0c5e1eec84c24fcd5579f1812c637e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "849085afbb3407fecc01f1d53fd311effde896350be3ca79dbe958789ac04f58"
    sha256 cellar: :any_skip_relocation, sonoma:         "1057ec4e9964451876978b2e013c638a890125ead5544ddef833ee9a4c257271"
    sha256 cellar: :any_skip_relocation, ventura:        "ebfc0873d65e3bc5923c9f586ba5aa4654677a0a64252cb3751c1820984179b8"
    sha256 cellar: :any_skip_relocation, monterey:       "a1821bb979a1ac217fae0d212c9fd691ebd1e8b41723351a58a73e17603d495f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3108b464d2b56a551965282655e8a1e730022b23be34ed675c54309e9754ff2d"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/96/aa/60bf19fe9d33cd8753b0547df513c3004b33b9a482800d3af0845bcbb3d0/astroid-3.0.3.tar.gz"
    sha256 "4148645659b08b70d72460ed1921158027a9e53ae8b7234149b1400eddacbb93"
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
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
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
