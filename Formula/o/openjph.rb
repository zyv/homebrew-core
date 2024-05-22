class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.13.3.tar.gz"
  sha256 "94413feb9cc18d6d25ffb2cdc7f941efabb69fce5a30b2e566f7dfc57d52622e"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ce51765de16488b153da8027d32f59c4a73c18b30f65b26606ae1ea04597a558"
    sha256 cellar: :any,                 arm64_ventura:  "fccb15dd419aa716cae487f8e2293a4976ce207dccc578a7233454b865754251"
    sha256 cellar: :any,                 arm64_monterey: "3fd767d37e9bd93b6300eedb3ce21c93ae6138807604e3e37e62a40d7f948420"
    sha256 cellar: :any,                 sonoma:         "16fc62957727709618bc3e88a23b0f2a36eed7d4069c413e08d36c7e65bec9cf"
    sha256 cellar: :any,                 ventura:        "5b1fecf8f300363d4be5bb70cb56c3ec59e7599be11db2bdddb6b17d370bfc98"
    sha256 cellar: :any,                 monterey:       "7fda9747898fd777c8943891279ead265c8e40aa6c70122f23acd536fddf157e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ece02940249e97d165cac6f79b98bae92a9149fa5aa3709117e15a5d29deb8eb"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test.ppm" do
      url "https://raw.githubusercontent.com/aous72/jp2k_test_codestreams/ca2d370/openjph/references/Malamute.ppm"
      sha256 "e4e36966d68a473a7f5f5719d9e41c8061f2d817f70a7de1c78d7e510a6391ff"
    end
    resource("homebrew-test.ppm").stage testpath

    system bin/"ojph_compress", "-i", "Malamute.ppm", "-o", "homebrew.j2c"
    system bin/"ojph_expand", "-i", "homebrew.j2c", "-o", "homebrew.ppm"
    assert_predicate testpath/"homebrew.ppm", :exist?
  end
end
