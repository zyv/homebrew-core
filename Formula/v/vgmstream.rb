class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1917",
      revision: "3ac217fad9989079d4fe92453b6f39c13f3261a0"
  version "r1917"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9d866183fd14d8cc60672a66bc2951e5ba6fef088f0c1f18364b43e37dd3e82"
    sha256 cellar: :any,                 arm64_ventura:  "a456abf3e5b6aed9c998b55e80741930cf34905cfd7bbb706cd7c0d35eef8fbb"
    sha256 cellar: :any,                 arm64_monterey: "f34ae184eaf0fddec4322078b53b9f177fa95ce7e1e38bb2679bdec508ebf489"
    sha256 cellar: :any,                 sonoma:         "68c38a3569afe428b6c94184537a876c5fe8c4e76c77cba24b1e6ef41a3b7ece"
    sha256 cellar: :any,                 ventura:        "53197ef2b9b776f81a735c199ecef7c5495fb97e2cd987aab7340a1659a4cb21"
    sha256 cellar: :any,                 monterey:       "75d00ad77223cdb095f8e4e0052df23dce5579cbd02461f5c608431b74ac01b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9daa41b3c2e228c150a9873e737c8315bc7392dd9f5f945c0841634acd92d648"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["LIBRARY_PATH"] = HOMEBREW_PREFIX/"lib"
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_AUDACIOUS:BOOL=OFF", "-DUSE_CELT=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/cli/vgmstream-cli", "build/cli/vgmstream123"
    lib.install "build/src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
