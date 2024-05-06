class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.05.06.00.tar.gz"
  sha256 "2e97b34db97cb2b328bf75b9528c8e2a9fc37e858a0c7982cd66dbd8911baa8a"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "48aa6dd249aae735e8725a3cfe2f975059ec316628f8cb314f2d4142849a8366"
    sha256 cellar: :any,                 arm64_ventura:  "0dc56008f56aaa9126c59a1bc235726dd387f288b02a85c8d5ee850b08383bdf"
    sha256 cellar: :any,                 arm64_monterey: "ad4b9196d8d2e3ff8a56f554a571ca77223c513bd7481df7717d5e1974fc3f02"
    sha256 cellar: :any,                 sonoma:         "c2bfa28c1b9870739ca75962e7f7ebfcd189c2b63991c90a42b578c5c86c35d2"
    sha256 cellar: :any,                 ventura:        "9b41f424759c7a46805e7d9e35c7813e5790ac78aa60d9a2935ad8d854ea5aba"
    sha256 cellar: :any,                 monterey:       "4fb0ccd312bb5fe3984e41a6ea7ed8b60231c351966cd614e0cf420972e33b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "637b92ddfb101bb1af0bc2cd1431dfa75f83feef4668038d36c5a95f3f20c5a6"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *shared_args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"
  end

  test do
    (testpath/"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath/"gen-cpp2", :exist?
    assert_predicate testpath/"gen-cpp2", :directory?
  end
end
