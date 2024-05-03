class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v3.1/tio-3.1.tar.xz"
  sha256 "09a22f2c9b08bd45dcdf98ffed220e4b26fd07db30854d5439e3806dea9dfa7b"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "49d690fa71c35f45a20b7afc935ae1b5186560e91cec074a32abb316776dbcdb"
    sha256 cellar: :any, arm64_ventura:  "d4178b03f30ce4844ba666d9a35295ce70e25889acc63672fbe85cdcc8aa2649"
    sha256 cellar: :any, arm64_monterey: "ec0f1e7c44d8cac8907806c3c71a6f4babe254c0929c5411702d257fdbf6690a"
    sha256 cellar: :any, sonoma:         "af07457bba5f2b694a81e390969806fc6bbd9654273bd333f1cf2471cc52509b"
    sha256 cellar: :any, ventura:        "7bd20a932c724f8b5f2ea06d7c6e52082f3a6ef017130d5149cb62999d44d6cd"
    sha256 cellar: :any, monterey:       "fab7296387ad4499e038b0994c94327da6f214b36b2879e5e08ae830a41aea48"
    sha256               x86_64_linux:   "a3d7a5d19b1ae7bdde02fe18b37e41df798ceac9e570f9fe5c41942ebd97a0d5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "lua"

  def install
    system "meson", "setup", "build", "-Dbashcompletiondir=#{bash_completion}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    expected = "Error: Not a tty device"
    output = if OS.mac?
      shell_output("script -q /dev/null #{bin}/tio /dev/null", 1).strip
    else
      shell_output("script -q /dev/null -e -c \"#{bin}/tio /dev/null\"", 1).strip
    end
    assert_match expected, output
  end
end
