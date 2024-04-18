class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/1.7.1/libxo-1.7.1.tar.gz"
  sha256 "fda4d9e52ff5258697e655bbe949111ac6ce0eddb346ce4997512d25fb7cfdd4"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_sonoma:   "a5b094f08b9981e2068fe3728f89508c5ac6e4967c5d0585e85078689d134989"
    sha256 arm64_ventura:  "101f62f03afd0b8c467d7c5718dcac41e608e39f08f75303d9b3d649562399b8"
    sha256 arm64_monterey: "9ca64335d6f81249608b132d73b3439d7e3d50972c6b3819f24630405004ec87"
    sha256 sonoma:         "3d49cf699c340e74a5126cedbe56cbec9a86d9289171ca35ffa25ea7650f1c4d"
    sha256 ventura:        "999951498e9bd916c7c7aacb7c10f7b7b7ca788812f216fac3f1400ec3eecb0e"
    sha256 monterey:       "b13e22c93cb87ccd3ce00d031198614f3c913afa4c59971f5286970430d7beba"
    sha256 x86_64_linux:   "42585b4229af157ea1f158909d44dab50b31baa98f7cb400e84299599c933e7a"
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
