class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v2.3.tar.gz"
  sha256 "e8980c64d3d80a74cdf05d6da15cd6fa31cfd0fa976c5f2c0485dc64536bcb8e"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3dc5008830d744665af05036bc9444b6bd2e17783c51c653dc47036ef376536a"
  end

  depends_on "pkg-config" => :build
  depends_on "chafa"
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "glib"
  depends_on "libvorbis"
  depends_on :linux
  depends_on "opusfile"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    man1.install "docs/kew.1"
  end

  test do
    (testpath/".config/kewrc").write ""
    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "Music not found", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end
