class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/refs/tags/1.4.1.tar.gz"
  sha256 "85311bf49ca536d0f0273c00796c2b5740ef0ce1f92e58f23ba4a078306e3c97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f46028597883cbc38864c61bd3fa402da9cb90ce97415d51a7b5279bc17f7bd0"
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
