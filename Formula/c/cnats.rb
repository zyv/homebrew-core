class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "465811380cdc6eab3304e40536d03f99977a69c0e56fcf566000c29dd075e4dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "540a06359b710df6c06be5c773401d82cb997b97f27747214020a94a22b1874a"
    sha256 cellar: :any,                 arm64_ventura:  "ef43f1e9688dc45c2bb6b79f505b5542d612b0b565064ef3d2bcac1c76786a61"
    sha256 cellar: :any,                 arm64_monterey: "c9881e81a1a301cf63e09368f14c331e0b24ab1b56cbc8521e5493b664ba6a49"
    sha256 cellar: :any,                 sonoma:         "4c4b827bc06eae5d47fe5f359ae0d6f0ac56b6ed8b73b64f086cc8a36f039cc7"
    sha256 cellar: :any,                 ventura:        "db9119864162dfd8b694ff85e5c19a3c509d94fc8d24cda8e87de1b9cca500b9"
    sha256 cellar: :any,                 monterey:       "a21f6d4f642ee02748db435d8b74f9ab1d15037e0823b275c436ce81dfc4662e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8269ed0b3b57acaeed56a0dac0fe5b24ae780a3db8fb7477e8b7e2f9be25df1b"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBUILD_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
