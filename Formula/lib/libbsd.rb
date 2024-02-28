class Libbsd < Formula
  desc "Utility functions from BSD systems"
  homepage "https://libbsd.freedesktop.org/"
  url "https://libbsd.freedesktop.org/releases/libbsd-0.12.1.tar.xz"
  sha256 "d7747f8ec1baa6ff5c096a9dd587c061233dec90da0f1aedd66d830f6db6996a"
  license "BSD-3-Clause"

  livecheck do
    url "https://libbsd.freedesktop.org/releases/"
    regex(/href=.*?libbsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aaf6688e821cb7bd671ccf9c5a7dcdd1b20d9e26e7d746ea9214af6ba7060156"
  end

  depends_on "libmd"
  depends_on :linux

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "strtonum", shell_output("nm #{lib/"libbsd.so.#{version}"}")
  end
end
