class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/94/d7/adb787076e65dc99ef057e0118e25becf80dd05233ef4c86f07aa35f6492/virtualenv-20.25.0.tar.gz"
  sha256 "bf51c0d9c7dd63ea8e44086fa1e4fb1093a31e963b86959257378aef020e1f1b"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33b549d8c2ce12a315931e0c07e6ec2862e0f989069470ede68d45ecd3c43d56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "653df5efc5b5bcfefc9b0118e14da23f751f0368effeb82eda5d614965db3d6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcf8a4b553761fee780e6c399a86544e689b27c96936d81b3eefdc78aa30b066"
    sha256 cellar: :any_skip_relocation, sonoma:         "4118d6e0ff85b6c48923aed30816c1f5a8c159c51116e5c225bff0ff1a16434f"
    sha256 cellar: :any_skip_relocation, ventura:        "fa567862f3a8ff84ede5048740779ceb8b561790bd3bc955fd8e934e880a6b79"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c9ac36f093dac699ee15c2a6c6e4de8554dedb9dbcc57e0ff23cab039da3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a88eb3ca67d40f32eec206a527905d038d58a57e833e611afe3cf93105598a28"
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

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
