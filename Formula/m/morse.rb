class Morse < Formula
  desc "QSO generator and morse code trainer"
  homepage "http://www.catb.org/~esr/morse/"
  # reported the artifact issue on the project page, https://gitlab.com/esr/morse-classic/-/issues/1
  url "https://gitlab.com/esr/morse-classic/-/archive/2.6/morse-classic-2.6.tar.bz2"
  sha256 "ec44144d52a1eef36fbe0ca400c54556a7ba8f8c3de38d80512d19703b89f615"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?morse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "3af87aea5f319406f1d7c0aac0820267902bbfbf8319fa266eca47797c020f34"
    sha256 cellar: :any,                 arm64_ventura:  "474e74791c30812618775445b3880cced2be0fff47467e1d386f2162644e4255"
    sha256 cellar: :any,                 arm64_monterey: "50a033c1ff5352adb6c0ccba3eb92e56f058e0f5b5a8bc4227e2f90a482bbb9e"
    sha256 cellar: :any,                 sonoma:         "7ed3a3ef9cb8489cd27be32667d9f128af18c351c0b7498fa8dbb979ef01b71d"
    sha256 cellar: :any,                 ventura:        "7b4ba57db993cdc7dbd7d5a171e69747c711e0bbbfb0f417cdb9ba9a4d1b54df"
    sha256 cellar: :any,                 monterey:       "737180d50656e9582f64aa525cfeaa48c94d552be158964c963ebc22fed131e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbd3a3a68b3ac4f584fd4cc13fc87699eb19d28079fda7e8f93a368fc5519432"
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "pulseaudio"

  patch :DATA

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV["CC"] = "#{ENV.cc} -Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make", "all"
    bin.install %w[morse QSO]
    man1.install %w[morse.1 QSO.1]
  end

  test do
    # Fails in Linux CI with "pa_simple_Write failed"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Could not initialize audio", shell_output("#{bin}/morse -- 2>&1", 1)
  end
end

__END__
diff --git a/Makefile b/Makefile
index 8bdf1f6..df39baa 100644
--- a/Makefile
+++ b/Makefile
@@ -28,8 +28,8 @@
 #DEVICE = X11
 #DEVICE = Linux
 #DEVICE = OSS
-DEVICE = ALSA
-#DEVICE = PA
+#DEVICE = ALSA
+DEVICE = PA

 VERSION=$(shell sed -n <NEWS '/^[0-9]/s/:.*//p' | head -1)
