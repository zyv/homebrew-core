class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/8.5.0.tar.gz"
  sha256 "ad62d4133c5a71978c753115c020e550f1008dc4c878d4306cdeb69790fe9813"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e12d89da8ff98c0f58ec18f358e55b299cca173305fed3633d05f94fd77f740"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a0c8da9c38539185f8ad6f6c95f6e998fc42d435394d52202f82870f5146af8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64e205cd80deef0e359df4cdf30ac0b9085469274ec90bf1b483e9524614af6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "91c811cdda8f7f92e673154443430e6214daa6bfeee8c58f89f51323fafa6580"
    sha256 cellar: :any_skip_relocation, ventura:        "3464d541360ba194d9f75cebd1cfac5aed98cbe8e493bff340ee9858b2ba3260"
    sha256 cellar: :any_skip_relocation, monterey:       "a029dea8b83c0b581d3c3f7fc63637b8b8e6801d3a6e87a8fb4bcd88036d9704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e55a4efa559afe0f776e67f1190a7d2654f9d51df8054159530d5bf57493b101"
  end

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE",
                            "-DENABLE_UNICODE:BOOL=TRUE"
      system "make", "install"
    end
  end

  test do
    (testpath/"json_test.f90").write <<~EOS
      program example
      use json_module, RK => json_RK
      use iso_fortran_env, only: stdout => output_unit
      implicit none
      type(json_core) :: json
      type(json_value),pointer :: p, inp
      call json%initialize()
      call json%create_object(p,'')
      call json%create_object(inp,'inputs')
      call json%add(p, inp)
      call json%add(inp, 't0', 0.1_RK)
      call json%print(p,stdout)
      call json%destroy(p)
      if (json%failed()) error stop 'error'
      end program example
    EOS
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end
