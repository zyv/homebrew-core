class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.16.5.tar.gz"
  sha256 "ba875edd164570958795eeaa70f14853bfc34cc9871f8adde8da47e12bd54679"
  license any_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  revision 1
  head "https://bitbucket.org/odedevs/ode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "270ce81f43aed519ba13d83987b7506873cc60163d0f09b09e6b4cd64c4c62d2"
    sha256 cellar: :any,                 arm64_ventura:  "26093d917736df12a0510654e0bc4d602d521a3c9c3dd09113401897f3acc317"
    sha256 cellar: :any,                 arm64_monterey: "b1da27ab0578179b232494c19eca7908d8a77da515894be35c93baa001d913c7"
    sha256 cellar: :any,                 sonoma:         "97d4f2c4c7e43015b3f5dffd884312f123818801e25f38a86e470d8a24e5f6b7"
    sha256 cellar: :any,                 ventura:        "08c2d6e501581a2e3bf1bd7975f00912d632ced10673d0372dd55489b2328850"
    sha256 cellar: :any,                 monterey:       "1d9407a8b74ce382bc76489d37f2b33e21830aae7b8dc11c2f9068190c022617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "389509a9254588ea10f1e0d888d7ed487ed509de9a07fff79cdee31ed4c856d5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libccd"

  # Fix -flat_namespace being used on Big Sur and later.
  # We patch `libtool.m4` and not `configure` because we call `./bootstrap`.
  patch :DATA

  def install
    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "./bootstrap"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-libccd",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-demos",
                          "--enable-double-precision"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ode/ode.h>
      int main() {
        dInitODE();
        dCloseODE();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/ode", "-L#{lib}", "-lode",
                   "-L#{Formula["libccd"].opt_lib}", "-lccd", "-lm", "-lpthread",
                   "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/m4/libtool.m4 b/m4/libtool.m4
index 10ab284..bfc1d56 100644
--- a/m4/libtool.m4
+++ b/m4/libtool.m4
@@ -1067,16 +1067,11 @@ _LT_EOF
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[[91]]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[[012]][[,.]]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[[012]],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
