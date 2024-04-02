class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.5.0/apache-pulsar-client-cpp-3.5.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.5.0/apache-pulsar-client-cpp-3.5.0.tar.gz"
  sha256 "eecd96ef2ef4e24505a06bf84d4b44e76058a5b4c7505539676f96c0fcda44f8"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d430f202dc9c85789de0678d8ca1dabed3c65b4c258eca82c052e1b7b023404d"
    sha256 cellar: :any,                 arm64_ventura:  "03c0139e9d075f34ab6a4e5001324c97d1702fec27011a3ab745ac33a4c4f095"
    sha256 cellar: :any,                 arm64_monterey: "5b5616eba6449d1d403a33ba73fd471284d2116cd356fba80279ce2c7a46360a"
    sha256 cellar: :any,                 sonoma:         "72f75853ce8b2114acefe6d8aa7469f89a4f12a35227ddaee5840e1da21083b6"
    sha256 cellar: :any,                 ventura:        "511125e0dcf5a6592827647219da1f0aa8d12f3902b34c064706f95953f76b6e"
    sha256 cellar: :any,                 monterey:       "8b62e6cd52c84b2d2f6a9d97fa80c8036f3605a1c45b3c0d2beb5d0f2a40d049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7981e99cb2f11265ffe299577de9499d5a7167c06f9a5c5a73936931e74a66d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON # protocolbuffers/protobuf#12292
      -Dprotobuf_MODULE_COMPATIBLE=ON # protocolbuffers/protobuf#1931
      -DCMAKE_CXX_STANDARD=17
    ]

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
