class Pnetcdf < Formula
  desc "Parallel netCDF library for scientific data using the OpenMPI library"
  homepage "https://parallel-netcdf.github.io/index.html"
  url "https://parallel-netcdf.github.io/Release/pnetcdf-1.13.0.tar.gz"
  sha256 "aba0f1c77a51990ba359d0f6388569ff77e530ee574e40592a1e206ed9b2c491"
  license "NetCDF"

  livecheck do
    url "https://parallel-netcdf.github.io/wiki/Download.html"
    regex(/href=.*?pnetcdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "3160f8422a4123ab25f4983adcbbc73d25da87f0e67964a41ce317029bd31871"
    sha256 arm64_ventura:  "3cc09465237f96557310cbb640b65b64361ec6b5bc953260b95d54a122006b5a"
    sha256 arm64_monterey: "1543e607fd7d317f0d235655c746f6e23e9b1f2646d366c4503008cab3b2ee1d"
    sha256 arm64_big_sur:  "3835889299b0058c33d17b94b2f1c57b21d10a00694d9a43c19ea95079035200"
    sha256 sonoma:         "73ad6f1c332533a6c5e0e6c921858ac41244cf4db80ce635cce9f500301e3d55"
    sha256 ventura:        "b854eb65a2c00049c3dc4fc5dc73894b6c611b22aa5b641099e6d138a1b3d9bf"
    sha256 monterey:       "026bca86c31dc0ce029f790e93db11616877121173a780aa4a3954864ebd347a"
    sha256 big_sur:        "2708f28a2cc2b81cb4ef5338219fdc644e23a666001ab0c622f3cfe97c731479"
    sha256 catalina:       "1d5b9405435f5c0621fd1214e2678e8a52c84b27da7f7540a3a6e7a4ccac7c50"
    sha256 x86_64_linux:   "315a952a703528f06ded6287166bfd92373ae53a8de6774ac32a638d322431a8"
  end

  depends_on "gcc"
  depends_on "open-mpi"

  uses_from_macos "m4" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Work around asm incompatibility with new linker (FB13194320)
    # https://github.com/Parallel-NetCDF/PnetCDF/issues/139
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-shared"

    system "make", "install"
  end

  # These tests were converted from the netcdf formula.
  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "pnetcdf.h"
      int main()
      {
        printf(PNETCDF_VERSION);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lpnetcdf",
                   "-o", "test"
    assert_equal `./test`, version.to_s

    (testpath/"test.f90").write <<~EOS
      program test
        use mpi
        use pnetcdf
        integer :: ncid, varid, dimids(2), ierr
        integer :: dat(2,2) = reshape([1, 2, 3, 4], [2, 2])
        call mpi_init(ierr)
        call check( nfmpi_create(MPI_COMM_WORLD, "test.nc", NF_CLOBBER, MPI_INFO_NULL, ncid) )
        call check( nfmpi_def_dim(ncid, "x", 2_MPI_OFFSET_KIND, dimids(2)) )
        call check( nfmpi_def_dim(ncid, "y", 2_MPI_OFFSET_KIND, dimids(1)) )
        call check( nfmpi_def_var(ncid, "data", NF_INT, 2, dimids, varid) )
        call check( nfmpi_enddef(ncid) )
        call check( nfmpi_put_var_int_all(ncid, varid, dat) )
        call check( nfmpi_close(ncid) )
        call mpi_finalize(ierr)
      contains
        subroutine check(status)
          integer, intent(in) :: status
          if (status /= nf_noerr) call abort
        end subroutine check
      end program test
    EOS
    system "mpif90", "test.f90", "-L#{lib}", "-I#{include}", "-lpnetcdf",
                       "-o", "testf"
    system "./testf"
  end
end
