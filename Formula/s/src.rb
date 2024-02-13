class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.35.tar.gz"
  sha256 "3b26de7da139b7fe77c5095a243e0ece55accccc45bd43c74fcc348b4553b255"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0ad4a4c93ef601b7308afce7486e7d3ad86dd9bb717c44fa3b5224fadb5f39c"
  end

  head do
    url "https://gitlab.com/esr/src.git", branch: "master"
    depends_on "asciidoc" => :build
  end

  depends_on "rcs"

  uses_from_macos "python", since: :catalina

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    require "pty"
    (testpath/"test.txt").write "foo"
    PTY.spawn("sh", "-c", "#{bin}/src commit -m hello test.txt; #{bin}/src status test.txt") do |r, _w, _pid|
      output = ""
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match(/^=\s*test.txt/, output)
    end
  end
end
