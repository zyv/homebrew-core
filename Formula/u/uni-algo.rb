class UniAlgo < Formula
  desc "Unicode Algorithms Implementation for C/C++"
  homepage "https://github.com/uni-algo/uni-algo"
  url "https://github.com/uni-algo/uni-algo/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f2a1539cd8635bc6088d05144a73ecfe7b4d74ee0361fabed6f87f9f19e74ca9"
  license "MIT"

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.0.2)
      project(utf8_norm LANGUAGES CXX)
      find_package(uni-algo CONFIG REQUIRED)
      add_executable(utf8_norm utf8_norm.cpp)
      target_link_libraries(utf8_norm PRIVATE uni-algo::uni-algo)
    EOS

    (testpath/"utf8_norm.cpp").write <<~EOS
      #include <uni_algo/norm.h>
      int main() {
        return (una::norm::to_nfc_utf8("W\u0302") == "Ŵ") ? 0 : 1;
      }
    EOS

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_PREFIX_PATH:STRING=#{opt_lib}"
    system "cmake", "--build", "build"
    system "build/utf8_norm"
  end
end
