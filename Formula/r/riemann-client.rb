class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://git.madhouse-project.org/algernon/riemann-c-client"
  url "https://git.madhouse-project.org/algernon/riemann-c-client/archive/riemann-c-client-2.2.1.tar.gz"
  sha256 "65daf32ad043ccd553a8314d1506914c2b71867d24b0e18380cb174e04861303"
  license "EUPL-1.2"
  head "https://git.madhouse-project.org/algernon/riemann-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "250573eb7623272bd39a641f8425c54e25166c9d6f00536411199b3519b35d8a"
    sha256 cellar: :any,                 arm64_ventura:  "c9e0c1d3a35bfe73bc5bc680c907519f23cc10de654c6b9f1020af02133ae834"
    sha256 cellar: :any,                 arm64_monterey: "b5b3a981e301f9b3a5ff8db896bdb2052b1125a515c7cdcb4d51fd6a2af2829a"
    sha256 cellar: :any,                 sonoma:         "952af9423fa3e8d590128d983107d5d209717f835f3c27fa9e4575fafccea41f"
    sha256 cellar: :any,                 ventura:        "27ab072b295b38bebaa72d9cc080739728104df3d1daf591bfeabf6b6f118ba4"
    sha256 cellar: :any,                 monterey:       "f4a2f5ac6aaf235950f83439d477423bdcb7f0985f9bba8cc58922a4ab59cc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08985d27aec02a506bf4aa2b6e59cfad8412d445cd8d91d59b67b87c017c406f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  # upstream build patch
  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}", "--with-tls=openssl"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end

__END__
diff --git a/Makefile.am b/Makefile.am
index caf43c5..9eb8f55 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -68,7 +68,7 @@ CLEANFILES			= ${proto_files}

 ${proto_files}: ${top_srcdir}/lib/riemann/proto/riemann.proto
 	${AM_V_at} ${mkinstalldirs} ${top_builddir}/lib/riemann/proto
-	${AM_V_GEN} protoc-c $^ -I${top_srcdir}/lib/riemann/proto --c_out=${top_builddir}/lib/riemann/proto
+	${AM_V_GEN} ${PROTOC} $^ -I${top_srcdir}/lib/riemann/proto --c_out=${top_builddir}/lib/riemann/proto

 if HAVE_VERSIONING
 lib_libriemann_client_@TLS@_la_LDFLAGS += \
diff --git a/README.md b/README.md
index f5dcc20..f525e27 100644
--- a/README.md
+++ b/README.md
@@ -128,3 +128,7 @@ If, for some reason the build fails, one may need to regenerate the
 `protobuf-c-compiler` generated headers (changes in the compiler are
 known to cause issues). To do this, do a `make distclean` first, and
 then start over from `configure`.
+
+If the protobuf-c compiler fails, and complains about `PROTO3` as maximum
+edition, install protobuf 26+ too, and either start over from `configure`, or
+set the `PROTOC` environment variable to `protoc`.
diff --git a/configure.ac b/configure.ac
index 8c4733c..4b48987 100644
--- a/configure.ac
+++ b/configure.ac
@@ -35,8 +35,8 @@ AC_PROG_CXX

 LT_INIT([shared])

-AC_CHECK_PROG([HAS_PROTOC_C], [protoc-c], [yes])
-if test x$HAS_PROTOC_C != x"yes"; then
+AC_CHECK_PROGS([PROTOC], [protoc protoc-c])
+if test -z "${PROTOC}"; then
    AC_MSG_ERROR([You need protoc-c installed and on your path to proceed. You can find it at https://github.com/protobuf-c/protobuf-c])
 fi

--
2.44.0
