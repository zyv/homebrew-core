class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/releases/download/5.5/MrBoom-src-5.5.tar.gz"
  sha256 "c37c09c30662b17f1c7da337da1475f534674686ce78c7e15b603eeadc4498f0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "52d35d88c499909adb4af2f64fda60551817a46b460c61a8c17b8474bcb1d232"
    sha256 cellar: :any,                 arm64_ventura:  "3996483952b0adeffbbc4278ef3b6bda8126d95a546b654eee4b401f5de5723a"
    sha256 cellar: :any,                 arm64_monterey: "7a31326ccb10334fa22093b1e5a8a7e6d89ce91dae5f8d4b07deff72f445773f"
    sha256 cellar: :any,                 sonoma:         "2d96f2c47865c3aadc45f8575f9ab1e5f1be8dabab94aa599f53a7597622a9d3"
    sha256 cellar: :any,                 ventura:        "b589ad16a54ccdda45a8d84548a775438239b58d9ffbd836d5a5e2a9c4e6e270"
    sha256 cellar: :any,                 monterey:       "6dd5ff9f550fb144780e410f009a4e32ec4345a52b3f34fbace4cd9f59c09183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9166996bcf8695dd6c5665e2d1c956b0d5614ea52d4a1af866f974bb497a7c57"
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=share/man/man6"
  end

  test do
    # mrboom is a GUI application
    assert_match version.to_s, shell_output("#{bin}/mrboom --version")
  end
end
