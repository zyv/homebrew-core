class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "01592f1f00e09eb5d3100629adb2f10e9491521891d42c0d01778ba386e49afc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddff9c532b8f13fe7f85436d1d700568f8237ea87c0b82b5c1cfc9b319cdecae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fe778077db42f28cd3b6fa2ba390f0521739a46d7e4ccf7a8b3a98eee9f3f8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc1f550bcc28bc4f5588a9aa86c7096571f27c6729ad2ffdf22613eb327597f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7e083cf7d2c68b4001903bfd3181fe702f9e16e3a0654f9b37ce8e4ac574dd6"
    sha256 cellar: :any_skip_relocation, ventura:        "5b9af1491b5385fef303b9905347182bfcdf22130e4781dafbe69a0ce1ae99c4"
    sha256 cellar: :any_skip_relocation, monterey:       "7753593f53a886542a3d452194623baf5288accbe90bb6b4cd71aa37592f2d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5523100a860eb38c3ada88fd37ff095b53c66ad7d20aba89025fdd580ac6ee55"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/rust2cpp/rust2cpp/.", testpath
    inreplace "CMakeLists.txt", "include(../../test_header.cmake)", "find_package(Corrosion REQUIRED)"
    system "cmake", "."
    system "cmake", "--build", "."
    assert_match "Hello, Cpp! I'm Rust!", shell_output("./cpp-exe")
  end
end
