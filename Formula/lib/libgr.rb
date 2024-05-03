class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.4.tar.gz"
  sha256 "41e8602c1df75b8d0fd73c505769a8aab13a0ac2544d908b806cf6f2f5b44ccc"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "9a2429935185c88b714a09ae390c0c0e193d66c45bbedf56f3bb2ea3ff0a9a36"
    sha256 arm64_ventura:  "e73b78f22afdd5384c1f9f89af96c5b5ce55dc91a925ff451a17a467c0e93690"
    sha256 arm64_monterey: "a72511523115a8385e8712aa2418b589758266493d3172889d6db2f89fa94379"
    sha256 sonoma:         "553fc5063450df57826cdf6e6449bb92a1ebac2351dfd961b950802740a2ed5e"
    sha256 ventura:        "eda07cd53aba4d8c42ecce759af98f8e835b6b3c675508b1ae8ae0b85ba83258"
    sha256 monterey:       "7fbdb24af03c3309e14799d7b9de709bcf834a5e16e4360f71890037d703ecf3"
    sha256 x86_64_linux:   "4d29e045ca8f0c8662623926cc927fb90b21f5929fb634ad1fe1762e1763fb38"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "ffmpeg@6"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <gr.h>

      int main(void) {
          gr_opengks();
          gr_openws(1, "test.png", 140);
          gr_activatews(1);
          double x[] = {0, 0.2, 0.4, 0.6, 0.8, 1.0};
          double y[] = {0.3, 0.5, 0.4, 0.2, 0.6, 0.7};
          gr_polyline(6, x, y);
          gr_axes(gr_tick(0, 1), gr_tick(0, 1), 0, 0, 1, 1, -0.01);
          gr_updatews();
          gr_emergencyclosegks();
          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_predicate testpath/"test.png", :exist?
  end
end
