class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/85/58/af8998eb853f8e2caa7bb931612bb0750a69877f17fa03ec8e6badfaf277/huggingface_hub-0.23.1.tar.gz"
  sha256 "4f62dbf6ae94f400c6d3419485e52bce510591432a5248a65d0cb72e4d479eb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fbde0f17aa110d71f10a52e9ee4b212ef183d7a948e2312c9ecf71e942b40f29"
    sha256 cellar: :any,                 arm64_ventura:  "a3e6e618293a587f939b55f4671153d23711419234feab7ae1f90b7c96b0f9db"
    sha256 cellar: :any,                 arm64_monterey: "671a361cf5497506f61ddb5e0816d82b45fda7133f3a1c79c5dfe4ab7592b11e"
    sha256 cellar: :any,                 sonoma:         "a348afc9bb0ab601975e3f7d8a24050f65a7d83429bca3e63b4e696b552d84ca"
    sha256 cellar: :any,                 ventura:        "eaa3f9bbed6600c0735335e3224642bf25c9cc69a31a18b22c947132c75860f8"
    sha256 cellar: :any,                 monterey:       "e283ffea802be6018aae080cce4cd5997139477bdf5a57ee4e3f798770ead2b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f011f0f367f94caac9c96aa9dcc18e152f051d611c9dd231da7afb52130e7bbd"
  end

  depends_on "certifi"
  depends_on "git-lfs"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/06/ae/f8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897ea/filelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/71/28/cbf337fddd6f22686b7c2639b80e006accd904db152fe333fd98f4cd8d1e/fsspec-2024.5.0.tar.gz"
    sha256 "1d021b0b0f933e3b3029ed808eb400c08ba101ca2de4b3483fbc9ca23fcee94a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/d8/c1/f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16/requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/5a/c0/b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2/tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    whoami_output = shell_output("#{bin}/huggingface-cli whoami")
    assert_match "Not logged in", whoami_output
    test_cache = testpath/"cache"
    test_cache.mkdir
    ENV["HUGGINGFACE_HUB_CACHE"] = test_cache.to_s
    ENV["NO_COLOR"] = "1"
    scan_output = shell_output("#{bin}/huggingface-cli scan-cache")
    assert_match "Done in 0.0s. Scanned 0 repo(s) for a total of 0.0.", scan_output
  end
end
