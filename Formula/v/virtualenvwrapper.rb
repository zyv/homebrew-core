class Virtualenvwrapper < Formula
  include Language::Python::Virtualenv

  desc "Python virtualenv extensions"
  homepage "https://virtualenvwrapper.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/4e/00/71629f631867c434e49fa276d659894c7cb5715f5de2233c10bc47c1fcc6/virtualenvwrapper-6.1.0.tar.gz"
  sha256 "d467beac5a44be00fb5cd1bcf332398c3dab5fb3bd3af7815ea86b4d6bb3d3a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a90e2263d38d0d3ab6dc6d1bafbd9e75d3d05471d078b3f16046aa4b61cfcde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c1072ed62c67138b7424ed34069cd8325564a2e0294cf7974cbffe4823dd7bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22013ed67797a18484d863188024430bb64951f6766ac51bb98cbd75696b4ea6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe67aba6cc7c349860a5afe5813f8d8eb5d998196cf3155f8ad5a4f1eb7e8b7a"
    sha256 cellar: :any_skip_relocation, ventura:        "de96173160e4b3185109f10d51ee254b73f567b7cc73abbb73b0c807b4a0c4ca"
    sha256 cellar: :any_skip_relocation, monterey:       "5931223a14d8c89970297f6298041b4b0fdbeb46ba41d8565aea9589b5180356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e98d276306cbdc9df1ee2f7fe5bfca450525492923c3b634b9dc1544a8be5016"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/e7/c1/b210bf1071c96ecfcd24c2eeb4c828a2a24bf74b38af13896d02203b1eec/stevedore-5.2.0.tar.gz"
    sha256 "46b93ca40e1114cea93d738a6c1e365396981bb6bb78c27045b7587c9473544d"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/93/4f/a7737e177ab67c454d7e60d48a5927f16cd05623e9dd888f78183545d250/virtualenv-20.25.1.tar.gz"
    sha256 "e08e13ecdca7a0bd53798f356d5831434afa5b07b93f0abdf0797b7a06ffe197"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def install
    virtualenv_install_with_resources

    (bin/"virtualenvwrapper.sh").unlink
    (bin/"virtualenvwrapper.sh").write <<~SH
      #!/bin/sh
      export VIRTUALENVWRAPPER_PYTHON="#{libexec}/bin/python"
      export VIRTUALENVWRAPPER_VIRTUALENV="${VIRTUALENVWRAPPER_VIRTUALENV:-#{libexec}/bin/virtualenv}"
      export VIRTUALENVWRAPPER_VIRTUALENV_CLONE="${VIRTUALENVWRAPPER_VIRTUALENV_CLONE:-#{libexec}/bin/virtualenv-clone}"
      source "#{libexec}/bin/virtualenvwrapper.sh"
    SH
  end

  def caveats
    <<~EOS
      To activate virtualenvwrapper, add the following to your shell profile
      e.g. ~/.profile or ~/.zshrc
        source virtualenvwrapper.sh
    EOS
  end

  test do
    assert_match "created virtual environment",
                 shell_output("bash -c 'source virtualenvwrapper.sh; mktmpenv'")
  end
end
