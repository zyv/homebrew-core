class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.9.0.tar.gz"
  sha256 "8b99c9dbb21c1309705073460be9bfacb6f7b0e83a15fe5d4b7140201b39d2a1"
  license "Apache-2.0"
  head "https://github.com/znc/znc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "11a519194072ba21ad36541e8e559f514e9a185cdc0c270b327effa16512e45f"
    sha256 arm64_ventura:  "715cf941fcfc7e6996e0cb9fe82ff0a95afb4a6e29e73cb863a15b1cbc9a081a"
    sha256 arm64_monterey: "55953112dd96fdf3be0928d482f0f54192a20b47e6277cec4aa8d4b29bdca792"
    sha256 sonoma:         "c6828c6787e7acce32fc13363d2102d2fc3813cd4228456db4563720d7916311"
    sha256 ventura:        "6b48dd78c1b5e606ce0e40380806dc57eb361052d8a8b4b3767033b547df9f07"
    sha256 monterey:       "b4c9210d6ad3fbecb1671ac6f449970b926bf8b23ce47c7dbd8acbc9ffac0256"
    sha256 x86_64_linux:   "a98c0ee38419f421ac3380517735a45263a21dee7ebb2bffa87d0f182ce2b632"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "zlib"

  def install
    python3 = "python3.12"
    xy = Language::Python.major_minor_version python3

    # Fixes: CMake Error: Problem with archive_write_header(): Can't create 'swigpyrun.h'
    ENV.deparallelize

    system "cmake", "-S", ".", "-B", "build",
                    "-DWANT_PYTHON=ON",
                    "-DWANT_PYTHON_VERSION=python-#{xy}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    inreplace lib/"pkgconfig/znc.pc", Superenv.shims_path/ENV.cxx, ENV.cxx
  end

  service do
    run [opt_bin/"znc", "--foreground"]
    run_type :interval
    interval 300
    log_path var/"log/znc.log"
    error_log_path var/"log/znc.log"
  end

  test do
    mkdir ".znc"
    system bin/"znc", "--makepem"
    assert_predicate testpath/".znc/znc.pem", :exist?
  end
end
