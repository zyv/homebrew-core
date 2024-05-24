class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://github.com/OSGeo/libgeotiff"
  license "MIT"

  stable do
    url "https://github.com/OSGeo/libgeotiff/releases/download/1.7.2/libgeotiff-1.7.2.tar.gz"
    sha256 "93c51fe139661d78092b30449293d28c230041d4e33ec3cabadeb167745c1177"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50d91e947c0969911681cab5955e6225642120376359f9e18e12c179d6b3316a"
    sha256 cellar: :any,                 arm64_ventura:  "a166acd2043b465027c51dd99511c6d36d0e821bd178f449acebb74bb49cd1ff"
    sha256 cellar: :any,                 arm64_monterey: "afed8abb5481dc95894186274a6836a415750e2954dc5ff94d4b9fcd5fc3691a"
    sha256 cellar: :any,                 sonoma:         "93f331ee2af0f7a43d840352d0c62275a37d7690a73a4838a1d101cef2a8bd35"
    sha256 cellar: :any,                 ventura:        "6dffe00210966a0a9d96cb7bf8ac2166a62cab3f10697e1f965eecfa28d151f2"
    sha256 cellar: :any,                 monterey:       "513fbaebba07eb6984a75c7eb48f73f4772ae5ba3c1f835f18dfa259a9d234c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b3e3ccfac32e6404fc1c3c77211d4d670f5b838e1daa3de67fdb4f686ce37af"
  end

  head do
    url "https://github.com/OSGeo/libgeotiff.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "proj"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--with-jpeg"
    system "make" # Separate steps or install fails
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "geotiffio.h"
      #include "xtiffio.h"
      #include <stdlib.h>
      #include <string.h>

      int main(int argc, char* argv[])
      {
        TIFF *tif = XTIFFOpen(argv[1], "w");
        GTIF *gtif = GTIFNew(tif);
        TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        GTIFKeySet(gtif, GeogInvFlatteningGeoKey, TYPE_DOUBLE, 1, (double)123.456);

        int i;
        char buffer[20L];

        memset(buffer,0,(size_t)20L);
        for (i=0;i<20L;i++){
          TIFFWriteScanline(tif, buffer, i, 0);
        }

        GTIFWriteKeys(gtif);
        GTIFFree(gtif);
        XTIFFClose(tif);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgeotiff",
                   "-L#{Formula["libtiff"].opt_lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    output = shell_output("#{bin}/listgeo test.tif")
    assert_match(/GeogInvFlatteningGeoKey.*123\.456/, output)
  end
end
