class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-4.0.0.tar.gz"
  sha256 "f083df763e3d8cbbd17060c77b3ecd88beb9ce6c7e7f87630b3debd1bb0091f9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "23612ab3cdac456c9fc5fd34554bc8dc4523c9b4ee7b0afa39595fbff09da603"
    sha256 cellar: :any,                 arm64_ventura:  "9ed7d5b25a2b4c07f614ec427d828104722030db63c3cd2437c7c015f70c7b8e"
    sha256 cellar: :any,                 arm64_monterey: "feaa4b155cddb90b7e2fd40d73608d081fc007ff89aefd3fb1f90bc4a3134cc4"
    sha256 cellar: :any,                 sonoma:         "aff5beada38dbfd166dd3417bb17a32e0fddd2fce41028e78fd472dc833d22b3"
    sha256 cellar: :any,                 ventura:        "7435bf4fd20c10e3bafb058f1086999afae1d0c67679d628d8ae0f213a03bf1c"
    sha256 cellar: :any,                 monterey:       "e2d5efc2ae19879722204a31044870d989ccf91d8a95edfe9bd500754f1c6444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "591da9c8bc2ef9191bcf0e186115a50424a819aef4201625a75a0d514b494f78"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_FORTRAN=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"testcalceph.c").write <<~EOS
      #include <calceph.h>
      #include <assert.h>

      int errorfound;
      static void myhandler (const char *msg) {
        errorfound = 1;
      }

      int main (void) {
        errorfound = 0;
        calceph_seterrorhandler (3, myhandler);
        calceph_open ("example1.dat");
        assert (errorfound==1);
        return 0;
      }
    EOS
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end
