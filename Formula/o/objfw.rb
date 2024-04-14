class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.1.tar.gz"
  sha256 "79f6a6fdc90ad6474206c8f649d66415b09a3f07b9c6ddbaf64129291fd12d94"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0978aef60f6c8f5befbfabd36b919e29bc78101e58176414cabee8676bab1562"
    sha256 arm64_ventura:  "87470e22a708f544472cc2285bb1110b64b7562eb77e0560cfd4726e2c026feb"
    sha256 arm64_monterey: "ba037cf7c4a0a734aff41da160f238b5dd349927d11e903e84c8889deca7700e"
    sha256 sonoma:         "2b09ae6011ad11b0e1f5bc933f2b80e245a7094044700d5bcfa7692754e2dc05"
    sha256 ventura:        "7f15900319612f011ee5138c37e6f49a607664eee5a43ccf0ac9d08e83e2a60f"
    sha256 monterey:       "b6f97c313c215e352153da89889db5cef43deef42191447d9e2027aed49b6426"
    sha256 x86_64_linux:   "d47b0cae0fb39f8f2376952ab5ccc23978e82dccdb9f27ed1d84e310c4ad6c3c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "llvm"
  end

  fails_with :gcc

  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    inreplace bin/"objfw-config", "llvm_clang", "clang" if OS.linux?
  end

  test do
    system "#{bin}/objfw-new", "--app", "Test"
    system "#{bin}/objfw-compile", "-o", "t", "Test.m"
    system "./t"
  end
end

__END__
diff --git a/build-aux/m4/buildsys.m4 b/build-aux/m4/buildsys.m4
index 3ec1cc5c..c0c31cac 100644
--- a/build-aux/m4/buildsys.m4
+++ b/build-aux/m4/buildsys.m4
@@ -323,7 +323,7 @@ AC_DEFUN([BUILDSYS_FRAMEWORK], [
 		AS_IF([test x"$host_is_ios" = x"yes"], [
 			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/Frameworks/$$out/$${out%.framework}'
 		], [
-			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/../Frameworks/$$out/$${out%.framework}'
+			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,${prefix}/Library/Frameworks/$$out/$${out%.framework}'
 		])
 
 		AC_SUBST(FRAMEWORK_LDFLAGS)

