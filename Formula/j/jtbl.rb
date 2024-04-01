class Jtbl < Formula
  include Language::Python::Virtualenv

  desc "Convert JSON and JSON Lines to terminal, CSV, HTTP, and markdown tables"
  homepage "https://github.com/kellyjonbrazil/jtbl"
  url "https://files.pythonhosted.org/packages/9e/7c/b21f3383ca611b56dbc281081cca73a24274c3f39654e7fe196d73a67af6/jtbl-1.6.0.tar.gz"
  sha256 "7de0cb08ebb2b3a0658229a8edd4204c6944cbd9e3e04724a9ea235a61c115a5"
  license "MIT"

  depends_on "python@3.12"

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/7a/53/afac341569b3fd558bf2b5428e925e2eb8753ad9627c1f9188104c6e0c4a/tabulate-0.8.10.tar.gz"
    sha256 "6c57f3f3dd7ac2782770155f3adb2db0b1a269637e42f27599925e64b114f519"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jtbl.1"
  end

  test do
    assert_match <<~EOS, pipe_output(bin/"jtbl", "[{\"a\":1,\"b\":1},{\"a\":2,\"b\":2}]")
        a    b
      ---  ---
        1    1
        2    2
    EOS

    assert_match version.to_s, shell_output("#{bin}/jtbl --version 2>&1", 1)
  end
end
