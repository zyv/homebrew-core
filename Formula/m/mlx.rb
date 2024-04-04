class Mlx < Formula
  desc "Array framework for Apple silicon"
  homepage "https://github.com/ml-explore/mlx"
  url "https://github.com/ml-explore/mlx/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "eac63ca7933fda7fda753537975cce6705801ee3231471e48abe35117eb62b05"
  license "MIT"
  head "https://github.com/ml-explore/mlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "c760292ddf548e5b6c78b0abca34e7ba1743bffe52cdc16f650c50110b694e0f"
    sha256 cellar: :any, arm64_ventura: "9272921dba268af487d746c4143efc9a5ba7448903348f0c2bac5118c0d07c44"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["14.3", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DMLX_BUILD_BENCHMARKS=OFF
      -DMLX_BUILD_EXAMPLES=OFF
      -DMLX_BUILD_METAL=OFF
      -DMLX_BUILD_PYTHON_BINDINGS=OFF
      -DMLX_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    env = { PYPI_RELEASE: version.to_s }
    env["DEV_RELEASE"] = "1" if build.head?
    env["MACOSX_DEPLOYMENT_TARGET"] = "#{MacOS.version.major}.#{MacOS.version.minor.to_i}" if OS.mac?
    with_env(env) do
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>

      #include <mlx/mlx.h>

      int main() {
        mlx::core::array x({1.0f, 2.0f, 3.0f, 4.0f}, {2, 2});
        mlx::core::array y = mlx::core::ones({2, 2});
        mlx::core::array z = mlx::core::add(x, y);
        mlx::core::eval(z);
        assert(z.dtype() == mlx::core::float32);
        assert(z.shape(0) == 2);
        assert(z.shape(1) == 2);
        assert(z.data<float>()[0] == 2.0f);
        assert(z.data<float>()[1] == 3.0f);
        assert(z.data<float>()[2] == 4.0f);
        assert(z.data<float>()[3] == 5.0f);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{include}", "-L#{lib}", "-lmlx",
                    "-o", "test"
    system "./test"

    (testpath/"test.py").write <<~EOS
      import mlx.core as mx
      x = mx.array(0.0)
      assert mx.cos(x) == 1.0
    EOS
    system python3, "test.py"
  end
end
