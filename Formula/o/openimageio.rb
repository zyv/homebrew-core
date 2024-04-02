class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.readthedocs.io/en/stable/"
  url "https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v2.5.10.0.tar.gz"
  sha256 "f9c56ad29e359a1debc2c983f6a078e434973765c01aead498a3fae52ce78ad0"
  license "Apache-2.0"
  head "https://github.com/AcademySoftwareFoundation/OpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Release[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c54b38f2d6cf72da3536193f9830cb3aaa116955366429996d8389bb906d9b20"
    sha256 cellar: :any,                 arm64_ventura:  "ba17b56993036b1eee972fa9b2398fe4ad76d36f66c4bd39de3bd6663acd3546"
    sha256 cellar: :any,                 arm64_monterey: "3581b6dd394acb05f436d1c0ef76f0c9bbadde14e2b269ac023584a0f4a0c84b"
    sha256 cellar: :any,                 sonoma:         "0772b1bf1f27fd2c08106b5f5fe7123209b8be3b6dc5de5cafa53dde1b79ce1d"
    sha256 cellar: :any,                 ventura:        "1ac4dfa109cebff6049516a394ad6ecc4f57aee9f390b417161cef324195cb43"
    sha256 cellar: :any,                 monterey:       "970e4f158aa5f793b3dc0d22c84ebc020ad05f8f8df4ad9a7483c82c896bb450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eb60a02e8eeeb0657618711b9da6f6c8ca4bdc2131b01ecfecced60d5d35e1e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "pugixml"
  depends_on "pybind11"
  depends_on "python@3.12"
  depends_on "webp"

  # https://github.com/AcademySoftwareFoundation/OpenImageIO/blob/master/INSTALL.md
  fails_with :gcc do
    version "5"
    cause "Requires GCC 6.1 or later"
  end

  def python3
    "python3.12"
  end

  def install
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = prefix/Language::Python.site_packages(python3)

    args = %W[
      -DPython_EXECUTABLE=#{which(python3)}
      -DPYTHON_VERSION=#{py3ver}
      -DBUILD_MISSING_FMT=OFF
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DOIIO_BUILD_TESTS=OFF
      -DUSE_DCMTK=OFF
      -DUSE_EXTERNAL_PUGIXML=ON
      -DUSE_JPEGTURBO=ON
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "#{test_image} :    1 x    1, 3 channel, uint8 jpeg",
                 shell_output("#{bin}/oiiotool --info #{test_image} 2>&1")

    output = <<~EOS
      from __future__ import print_function
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    EOS
    assert_match version.major_minor_patch.to_s, pipe_output(python3, output, 0)
  end
end
