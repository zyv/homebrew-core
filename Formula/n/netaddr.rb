class Netaddr < Formula
  include Language::Python::Virtualenv

  desc "Network address manipulation library"
  homepage "https://netaddr.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/54/e6/0308695af3bd001c7ce503b3a8628a001841fe1def19374c06d4bce9089b/netaddr-1.2.1.tar.gz"
  sha256 "6eb8fedf0412c6d294d06885c110de945cf4d22d2b510d0404f4e06950857987"
  license "BSD-3-Clause"
  head "https://github.com/netaddr/netaddr.git", branch: "master"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output(bin/"netaddr info 10.0.0.0/16")
    assert_match "Usable addresses         65534", output
  end
end
