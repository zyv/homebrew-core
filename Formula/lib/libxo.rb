class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/1.7.4/libxo-1.7.4.tar.gz"
  sha256 "adee0d024bda9bb1b76504cd48336c30c9dac771dad7e0d982315f3e0e3c103c"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_sonoma:   "f3abcec652ba9ae49c9227187391225de9b9f9759a8e4ca13e87f2b1acf2e313"
    sha256 arm64_ventura:  "aea81843d6ce92b65d5fc6600022cb9827567d1837f42a12647e55ee85a78f32"
    sha256 arm64_monterey: "a02e41c891be25e501d7225a2f9ea0abf59dd1dfe231ac9ec01d14703cafb360"
    sha256 sonoma:         "d5f2fee7470abadb91b9520c71d20f917e2073ab6b250775518f85dff664f29c"
    sha256 ventura:        "7b9e10ebb54fcb44eb7717d148a2546cbaf2a6c98cfda8caccc287be2f177891"
    sha256 monterey:       "58f7b048f208fd0b7b3d015b3eb84ba923bd69a1fffdbcfcb398e5befd7b2319"
    sha256 x86_64_linux:   "ec8c43fd1ff1daf9171c64c48fcf942a475d8a9881b3e0584a5e49472ab55bf5"
  end

  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end
