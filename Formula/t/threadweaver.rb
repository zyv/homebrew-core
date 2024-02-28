class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.0/threadweaver-6.0.0.tar.xz"
  sha256 "ba9daec6e0697fdc2accf74a46a6d59403e5e340d280bce916fd6356a668ddb3"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb3989ba81b4a92fe2ac8f2a3b6d218b18431629b11d299ceed2022e413d2397"
    sha256 cellar: :any,                 arm64_ventura:  "78790e4f019dd1745b5950cccf6043c6f7040920ba32e858634d2f2ec9f75065"
    sha256 cellar: :any,                 arm64_monterey: "fe17fb3069894f187ec27506e12f513d13ab282ad19d04f41a06e9b9b838332b"
    sha256 cellar: :any,                 sonoma:         "c5275182fe64258e97213d607313c57dcd9106bfcf524800a3a38abcb24e02dd"
    sha256 cellar: :any,                 ventura:        "d19358856e9b60c789c74c27d9050fea14ad6ee9ff89bcb83711ea08a9edaa77"
    sha256 cellar: :any,                 monterey:       "117d9807b7463ff5951ff4f99b7b85dfe6d1f9a87044962c3f0d1c3382a88ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0ace1ba956040585ecbe6abeed859f4dfade258917f8059073d9da0fc72f0e9"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "qt"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/HelloWorld").children, testpath

    kf = "KF#{version.major}"
    (testpath/"CMakeLists.txt").unlink
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(HelloWorld LANGUAGES CXX)
      find_package(ECM REQUIRED NO_MODULE)
      find_package(#{kf}ThreadWeaver REQUIRED NO_MODULE)
      add_executable(ThreadWeaver_HelloWorld HelloWorld.cpp)
      target_link_libraries(ThreadWeaver_HelloWorld #{kf}::ThreadWeaver)
    EOS

    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "cmake", "--build", "."

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
