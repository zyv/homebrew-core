class Pciutils < Formula
  desc "PCI utilities"
  homepage "https://github.com/pciutils/pciutils"
  url "https://github.com/pciutils/pciutils/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "464644e3542a8d3aaf5373a2be6cb9ddfaa583cb39fbafbbedc10ca458fb48a1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "7c9e9637f605a3a053848a968060f098e7f2e1ed88f2aaa53c4dabf178b9b344"
  end

  depends_on :linux
  depends_on "zlib"

  def install
    args = ["ZLIB=yes", "DNS=yes", "SHARED=yes", "PREFIX=#{prefix}", "MANDIR=#{man}"]
    system "make", *args
    system "make", "install", *args
    system "make", "install-lib", *args
  end

  test do
    assert_match "lspci version", shell_output("#{bin}/lspci --version")
    assert_match "Host bridge:", shell_output("#{bin}/lspci")
  end
end
