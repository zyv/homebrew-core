class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/refs/tags/1.4.2.tar.gz"
  sha256 "b44a205ee7ebdee22f83d2a7a87742172295b8086b5361850dfab4f49699e44f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c86f68ce6866dc07b2e7a0ed17b639e1236bc998574a1c6d36214cef3bf751ae"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fennel"

    lua = Formula["lua"]
    (share/"lua"/lua.version.major_minor).install "fennel.lua"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
