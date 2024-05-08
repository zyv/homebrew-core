class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.0.3/libjpeg-turbo-3.0.3.tar.gz"
  sha256 "343e789069fc7afbcdfe44dbba7dbbf45afa98a15150e079a38e60e44578865d"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "898ba61a84a444ef98b577162e49a0b06d65e8bdc48ad039d364fef4b4c00b05"
    sha256 cellar: :any,                 arm64_ventura:  "0a007662b26322a0985f31cc7546124f53caa8334f5d2f1e8356e9d7321fe420"
    sha256 cellar: :any,                 arm64_monterey: "5c179a6035798dab056356c288284ed695dc9505e4df4aa9868341fb9971a008"
    sha256 cellar: :any,                 sonoma:         "4e2af273b76b2f4845b08d0f249630212e41a76b113e7d633d319cc6cfb43bef"
    sha256 cellar: :any,                 ventura:        "91d8bf0169ff83cdccddd64e88fb7ebdcc2df2d799c93ffb2a6fddd3980b631d"
    sha256 cellar: :any,                 monterey:       "6f004f77f070e05df1c7303e90b4befb100dd831fe68f998996a2a5de60b59d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b16eab4c9fc8814b11ce6e43dd7d599587ec34ebbba7e1359e15bcff42ae672e"
  end

  depends_on "cmake" => :build

  on_intel do
    # Required only for x86 SIMD extensions.
    depends_on "nasm" => :build
  end

  # These conflict with `jpeg`, which is now keg-only.
  link_overwrite "bin/cjpeg", "bin/djpeg", "bin/jpegtran", "bin/rdjpgcom", "bin/wrjpgcom"
  link_overwrite "include/jconfig.h", "include/jerror.h", "include/jmorecfg.h", "include/jpeglib.h"
  link_overwrite "lib/libjpeg.dylib", "lib/libjpeg.so", "lib/libjpeg.a", "lib/pkgconfig/libjpeg.pc"
  link_overwrite "share/man/man1/cjpeg.1", "share/man/man1/djpeg.1", "share/man/man1/jpegtran.1",
                 "share/man/man1/rdjpgcom.1", "share/man/man1/wrjpgcom.1"

  def install
    args = ["-DWITH_JPEG8=1", "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"]
    # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/709
    if Hardware::CPU.arm? && MacOS.version >= :ventura
      args += ["-DFLOATTEST8=fp-contract",
               "-DFLOATTEST12=fp-contract"]
    end
    # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/734
    args << "-DFLOATTEST12=no-fp-contract" if Hardware::CPU.arm? && MacOS.version == :monterey
    args += std_cmake_args.reject { |arg| arg["CMAKE_INSTALL_LIBDIR"].present? }

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--rerun-failed", "--output-on-failure", "--parallel", ENV.make_jobs
    system "cmake", "--install", "build"
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose",
                           "-perfect",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
    assert_predicate testpath/"out.jpg", :exist?
  end
end
