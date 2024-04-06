class Pciutils < Formula
  desc "PCI utilities"
  homepage "https://github.com/pciutils/pciutils"
  url "https://github.com/pciutils/pciutils/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "3a76ca02581fed03d0470ba822e72ee06e492442a990062f9638dec90018505f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "ea4685bfdd96999e849fb9ac842707cac9965a755f116f86c9ed82614d480de7"
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
