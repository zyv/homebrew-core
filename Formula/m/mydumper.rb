class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.16.3-2.tar.gz"
  sha256 "6a3265cf7f168ec435a37ee5a06dafff6008d62af0ac6d1dec1e401247761c53"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c73699fd6f7f154b0b4ed3171a4a67796be8cea08d521feb7ac7548368be4b0"
    sha256 cellar: :any,                 arm64_ventura:  "3ef395afb8da87a26535835f3a6f67276ba23a2551053dd413880adf1955094d"
    sha256 cellar: :any,                 arm64_monterey: "1c59eb37914534ce9ae86e5fdfc0561e7e7f8cc13b871130933f9d6e40de2868"
    sha256 cellar: :any,                 sonoma:         "f115f11d53dc4dd905c9dad6eb0219b862b3c452f00b4fe18838f8513e3c0a20"
    sha256 cellar: :any,                 ventura:        "8eb8744a92c5215a0c6ae1fa1f4e3c2e6c347576636effc90621cb4312ce8ad0"
    sha256 cellar: :any,                 monterey:       "6ea81299f6d6962f7c6a753ca72fe09c39236a1767d7e80d7992d0a6f0bd331c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fa43a6da4f1aece0e8494b81d58be56c98f750d628d8ee28e150b1bf91e9477"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "pcre"
  depends_on "zlib"

  fails_with gcc: "5"

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = std_cmake_args + %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}
      -DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib/shared_library("libmysqlclient")}
    ]
    # find_package(ZLIB) has trouble on Big Sur since physical libz.dylib
    # doesn't exist on the filesystem.  Instead provide details ourselves:
    if OS.mac?
      args << "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1"
      args << "-DZLIB_INCLUDE_DIRS=/usr/include"
      args << "-DZLIB_LIBRARIES=-lz"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
