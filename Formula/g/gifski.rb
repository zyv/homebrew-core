class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.14.1.tar.gz"
  sha256 "43b31da37c1e59615a850dfe3e93c93aa09ce29ddfc47518d3ea8782711a72a5"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f1765df5d4f7af4ee09dd401806a31d959a8d7cac3abb60aa80e7b6e4f538516"
    sha256 cellar: :any,                 arm64_ventura:  "b60eb2f5ee2c5503b06581e9653259e292147e650b22bba577f488b20cb262e0"
    sha256 cellar: :any,                 arm64_monterey: "3278e6a28dd4faf9aeb6eacf275beaecbaa139880a9fc8a91dd198c3e668f657"
    sha256 cellar: :any,                 sonoma:         "3643f65e11741d688f099210bd2a68930b98d8ff5cb3b8aeea4a67d560bf9d8d"
    sha256 cellar: :any,                 ventura:        "42983d2adcc25875f469d04b255b9b63579ad6038bbea31a81c9bf93601b1a92"
    sha256 cellar: :any,                 monterey:       "80a3b483c1af00bdf8cd271e17f0449091c7ab480aef555c79e181dca5e1ec41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b26b067e6b6ea9c69083a2fcb12f80ef8434f6ed52452a33e000d2e6c97ab263"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
