class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "d8d8e632d77171c810c0f38f8d5c8387470ca19b75f5b80ad4d3d12007280288"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8f0c2b7fc94018818e368fe539e533f58cb7bb6223fbedb08118153f57366564"
    sha256 cellar: :any, arm64_ventura:  "3669abca9f9a4920fe97d08c318bb24ed7a42e203c40d814f42860f2f9054943"
    sha256 cellar: :any, arm64_monterey: "62bbd8250633c21c5be47eca0087c81d1066b1f07ee33c77772c059f8158a707"
    sha256 cellar: :any, sonoma:         "40dcc27c71be76c8894f02fb0721134c028f0d43da61356c809e10685eb47cf2"
    sha256 cellar: :any, ventura:        "4459fbe2d70bdb75452b9933292d24cf1253d8430465f0d85fad23f82baffe06"
    sha256 cellar: :any, monterey:       "874d511bb6038cd75a206d2d2ab0027baea27abfc3512dadc601d629b33d739e"
  end

  depends_on "cmake" => :build
  depends_on "embree"
  depends_on "ispc"
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/refs/tags/v1.12.0.tar.gz"
    sha256 "6abb901073811cdbcbe336772e1fcb458d78cab5ad8d5d61de2b57ab83581e80"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/refs/tags/v2.0.0.tar.gz"
    sha256 "469c3fba254c4fcdd84f8a9763d2e1aaa496dc123b5a9d467cc0a561e284c4e6"
  end

  def install
    resources.each do |r|
      r.stage do
        args = %W[
          -DCMAKE_INSTALL_NAME_DIR=#{lib}
          -DBUILD_EXAMPLES=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
    end

    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DOSPRAY_ENABLE_APPS=OFF
      -DOSPRAY_ENABLE_TESTING=OFF
      -DOSPRAY_ENABLE_TUTORIALS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <ospray/ospray.h>
      int main(int argc, const char **argv) {
        OSPError error = ospInit(&argc, argv);
        assert(error == OSP_NO_ERROR);
        ospShutdown();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lospray"
    system "./a.out"
  end
end
