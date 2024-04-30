class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.12.0.tar.gz"
  sha256 "e73fd0b12d95c0b61884579f61c26da7461335146e7e9c84f4a2dd5c9325bb4f"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d6bdef41ea4a680dc1b343f0a96e6f6ca3a5cb4bacea5ead519c419dfa924218"
    sha256 cellar: :any,                 arm64_ventura:  "6809d3d23d79c0f75b80798d45d0bb7f78950625ce27ad404e89c224c4db4781"
    sha256 cellar: :any,                 arm64_monterey: "ca42e33fc828e949c6c183a7d189c1dd8bae533ebac3b986bb68d05c27268d3b"
    sha256 cellar: :any,                 sonoma:         "f3f7964aff4f7d84702724fdb077fc932d734c0b4f1c08a9c10f92e2d0b120d1"
    sha256 cellar: :any,                 ventura:        "5bf2af96d153ca40b4d8580adbee3c6279e718b43cf76829659e9d6a55b69979"
    sha256 cellar: :any,                 monterey:       "17b163144236312f440a3f6533ebdcc5591d24637ac01bc70fbe7ff9e3597aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65ff24db33a7421b31219a4ea025b4a39868d68801db15c9aa0ddfbb5e70208a"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DOJPH_DISABLE_INTEL_SIMD=ON" if Hardware::CPU.arm?

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
