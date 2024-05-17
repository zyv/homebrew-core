class Apkleaks < Formula
  include Language::Python::Virtualenv

  desc "Scanning APK file for URIs, endpoints & secrets"
  homepage "https://github.com/dwisiswant0/apkleaks"
  url "https://files.pythonhosted.org/packages/40/88/8aa234dd5f7e632605dcce90d076982d4d1124d7278991ee54ec9e543cef/apkleaks-2.6.2.tar.gz"
  sha256 "f6f767dd758d2fd1395186709e736402ab6f913a6172e29220d6581035aa76fc"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d8df4ef44a466a0e00e9abbe8a375322148f34fc39621c88d22a1fc37ea34c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ecd4655efb2c5e266812c035008f0c0b03dcb3e6310d2e4dbf8ed85796991d8"
    sha256 cellar: :any,                 arm64_monterey: "cb27c0247f7325fad32bef4085ce3369f6745181fffcb5de9b9b9d131373f7bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f3dbb82d41744318d240dda745c47735f1be1d428d9ef9775e6b72d793a052f"
    sha256 cellar: :any_skip_relocation, ventura:        "d23a7d5319c5adcbb6a43a4e7d1f8f9b9edae999b3c78fb5efbf175ca2d7d200"
    sha256 cellar: :any,                 monterey:       "a1163739b862fcb3d329c98df1e402b90a1ee20156f0c42bf25a933002e99c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f79de53f7223113dcefdb5cfc78efcb17e6d17a7bf40987f186db5e6dc955ad"
  end

  depends_on "jadx"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "pyaxmlparser" do
    url "https://files.pythonhosted.org/packages/1e/1f/7a7318ad054d66253d2b96e2d9038ea920f17c8a9bd687cdcfa16a655bdf/pyaxmlparser-0.3.31.tar.gz"
    sha256 "fecb858ff1fb456466f8dcdcd814207b4c15edb95f67cfe0a38c7d7cd4a28d4d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test.apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    testpath.install resource("homebrew-test.apk")
    output = shell_output("#{bin}/apkleaks -f #{testpath}/redex-test.apk")
    assert_match "Decompiling APK...", output
    assert_match "Scanning against 'com.facebook.redex.test.instr'", output

    assert_match version.to_s, shell_output("#{bin}/apkleaks -h 2>&1")
  end
end
