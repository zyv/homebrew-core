class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "https://autotrace.sourceforge.io"
  url "https://github.com/autotrace/autotrace/archive/refs/tags/0.31.10.tar.gz"
  sha256 "14627f93bb02fe14eeda0163434a7cb9b1f316c0f1727f0bdf6323a831ffe80d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/autotrace/autotrace.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "imagemagick"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pstoedit"

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].opt_libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./autogen.sh"
    system "./configure", "--enable-magick-readers",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system "convert", "-size", "1x1", "canvas:black", "test.png"
    system "convert", "test.png", "test.bmp"
    output = shell_output("#{bin}/autotrace -output-format svg test.bmp")
    assert_match "<svg", output
  end
end
