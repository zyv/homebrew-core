class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.14.4.tar.gz"
  sha256 "7d6b1400833c31f6a24aac3a1b5d44c466e07f98af6d6c17487a7c8c6f4aa519"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "75381411b659343da31b34a96538ea3a48d242a492fa29646796924b9a5decf2"
    sha256 cellar: :any,                 arm64_ventura:  "69b487179ae7caf23aab9d5a3e4da60bc5e23e1639d24ace7d52eee400997472"
    sha256 cellar: :any,                 arm64_monterey: "9f7785e46df2313536a027b07075f99937576548a4e25b9316b16f0d4c455123"
    sha256 cellar: :any,                 sonoma:         "468c7c8476651a64b1bc955043b6d5fae589dc4b27f52afc8ab11cccc152d96d"
    sha256 cellar: :any,                 ventura:        "af79480734817566bb9c8537116d1ef3326abe7c5cea8cf771e4461feb1dcaef"
    sha256 cellar: :any,                 monterey:       "2d9d354ddc05f9ce4fc6ee8f3587624463f3f1eff188a71987f202f668d9e748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8681a91b8fc6525b06c5be3229709a0f90c7a9a42c3b1ba243022704e9b28feb"
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
