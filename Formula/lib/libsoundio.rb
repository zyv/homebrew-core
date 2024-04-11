class Libsoundio < Formula
  desc "Cross-platform audio input and output"
  homepage "http://libsound.io"
  url "https://github.com/andrewrk/libsoundio/archive/refs/tags/2.0.1-6.tar.gz"
  sha256 "af36d67d76fda4f17c8a1e2f7a6dd5f83a377d824e42ebe3524df0e8880abf21"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89ac9bf50666acf58cde9fba6a0c79f4225bb7b57d59f041a69a1d134b6c190a"
    sha256 cellar: :any,                 arm64_ventura:  "6ad5b12b69952ecc264d4c9bd3f50887f725324712c3442533b4abb67cdfa788"
    sha256 cellar: :any,                 arm64_monterey: "ee2c21b4512b374f66a2a9c392d7e1690b60adb0252998753cc7efc94bdb7845"
    sha256 cellar: :any,                 sonoma:         "4ec730c41601e8e59b54bffb2b82fab7de06d929241ff9286e40a25131cb455a"
    sha256 cellar: :any,                 ventura:        "1d62119eda28b70dd91dcb571198fc9976b62687cc55e725d3d49a981ffd40a0"
    sha256 cellar: :any,                 monterey:       "af99e9ca8d1894dbab645bea5b5efaf24718dc151b1e212651c4032a69af42bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f37bc1a4f4d602f60f8e5a20b3a0f4eb45c2df24463bcfe08781a331f9ae763"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <soundio/soundio.h>

      int main() {
        struct SoundIo *soundio = soundio_create();

        if (!soundio) { return 1; }
        if (soundio_connect(soundio)) return 1;

        soundio_flush_events(soundio);
        soundio_destroy(soundio);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lsoundio", "-o", "test"
    system "./test"
  end
end
