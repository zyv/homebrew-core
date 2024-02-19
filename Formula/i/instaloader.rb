class Instaloader < Formula
  include Language::Python::Virtualenv

  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/65/2d/ffcd7916414b5bce2a497c39f015ec55e754f165a254cf3ac8ec76f3dc0e/instaloader-4.10.3.tar.gz"
  sha256 "168065ab4bc93c1f309e4342883f5645235f2fc17d401125e5c6597d21e2c85b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6c434f54b809056fee9a5acadd3552b49cbd6cc62f7ad0f2e5215733f9869e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9254edfbc8fa3a2ad60a4ebd18a4584e7aa0a761e2aa240a9d0dd08758cf837"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e339cb1efb4d2542583a345d3fe6233c7b6e77f774c8f3d04204456f7b46a22a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb3231e46e9398ec7f9a6e0ec75f06e02d30dc432c8c2c48843e0bb0f9f2f8dd"
    sha256 cellar: :any_skip_relocation, ventura:        "dee8da1771db8dbf7eab558981cdd422edd0f90dbafa7073cd7270153b8ea93e"
    sha256 cellar: :any_skip_relocation, monterey:       "85c9374f7f0d7967cc532142090661e1a347810e4bbcb2ab84ef9a3764bf5f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b608a4fa79a82bba5225ba00c8a931631637efce8c4c06a6d65e0a11940ba78"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/instaloader --login foo --password bar 2>&1", 1)
    assert_match "Fatal error: Login error:", output

    assert_match version.to_s, shell_output("#{bin}/instaloader --version")
  end
end
