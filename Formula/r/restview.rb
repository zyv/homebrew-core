class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/10/93/20516dada3c64de14305fd8137251cd4accaa7eba15b44deb1f2419aa9ff/restview-3.0.1.tar.gz"
  sha256 "8c1a171c159d46d15d5569f77021828883a121d6f9baf758d641fc1e54b05ae5"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c2c1e9644f738c54a085b51d220af690897518d11f553397c5abefeaf445d01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5210f186429a421ad538c68c9691eb75f9f82672272eded412452096075a9a15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29b87b6d761847fbc10cd31dbfa6191fa8dc7a3478eec0719d7ae296109c7f7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8447d46fae305f35d3dd7bb976753f76b76568e4ea9746a8a972131b71c6dde1"
    sha256 cellar: :any_skip_relocation, ventura:        "907b93b8222821255a1fce0f4d55e7ad7ed2bceefe230bb829b9f3bc844ec644"
    sha256 cellar: :any_skip_relocation, monterey:       "97c1469ca2fc25a10abe1c81254b40269480a157b32f073722fb7b6c0fb5aa5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9166e1a0ffdbe51501417f6916a94f98f1a5e030e38a457d6faafc2744f723ba"
  end

  depends_on "python@3.12"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/6d/10/77f32b088738f40d4f5be801daa5f327879eadd4562f36a2b5ab975ae571/bleach-6.1.0.tar.gz"
    sha256 "0a31f1837963c41d46bbf1331b8778e1308ea0791db03cc4e7357b97cf42a8fe"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/1f/53/a5da4f2c5739cf66290fac1431ee52aff6851c7c8ffd8264f13affd7bcdd/docutils-0.20.1.tar.gz"
    sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/15/4e/0ffa80eb3e0d0fcc0c6b901b36d4faa11c47d10b9a066fdd42f24c7e646a/readme_renderer-36.0.tar.gz"
    sha256 "f71aeef9a588fcbed1f4cc001ba611370e94a0cd27c75b1140537618ec78f0a2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.rst").write <<~EOS
      Lists
      -----

      Here we have a numbered list

      1. Four
      2. Five
      3. Six
    EOS

    port = free_port
    begin
      pid = fork do
        exec bin/"restview", "--listen=#{port}", "--no-browser", "sample.rst"
      end
      sleep 3
      output = shell_output("curl -s 127.0.0.1:#{port}")
      assert_match "<p>Here we have a numbered list</p>", output
      assert_match "<li>Four</li>", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end
