class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.1.5/gucharmap-15.1.5.tar.bz2"
  sha256 "45c46e854a7de1a6491e6b3b0f3acd6363de1110208bdf5ba88d4e9460e9a897"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "429f1a90413aed4023917ddba7234d9e58f5a44884a467c4e9384b68af91b4d1"
    sha256 arm64_ventura:  "7ec4f04354ad5af4c6676a2d8cfb798c61f557c7f6728f2accc137af67a577f1"
    sha256 arm64_monterey: "642ef8dfcf4d6d8af82bd87e4d8a17b2ae1cfd4472fd9f5da62ccdae05e0d2c9"
    sha256 sonoma:         "0d3c46122c2ebd6d842999e1bfb7c9adaaace89d6bc814411e5e9756dcb62e26"
    sha256 ventura:        "d3f196b9c90ab48bad085eebac8f4ba06e0e050db2de0513b65cb215c2b57b65"
    sha256 monterey:       "dd81bffcf297e2443b2c86275d563047c6198df13cb6171e01207587228de5e9"
    sha256 x86_64_linux:   "bdf5f9a6612c4248a875314a1667d2022ea829f092de34b64bc703f6c3bca782"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"
  depends_on "pcre2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build
  end

  resource "ucd" do
    url "https://www.unicode.org/Public/15.1.0/ucd/UCD.zip"
    sha256 "cb1c663d053926500cd501229736045752713a066bd75802098598b7a7056177"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/16.0.0/ucd/Unihan.zip", using: :nounzip
    sha256 "faed0321cf85bbc18fd3edb5f03dbae9d7099ea712d75f08d1fb2f87dcc197e1"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    (buildpath/"unicode").install resource("ucd")
    (buildpath/"unicode").install resource("unihan")

    # ERROR: Assert failed: -Wl,-Bsymbolic-functions is required but not supported
    inreplace "meson.build", "'-Wl,-Bsymbolic-functions'", "" if OS.mac?

    system "meson", "setup", "build", "-Ducd_path=#{buildpath}/unicode", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
