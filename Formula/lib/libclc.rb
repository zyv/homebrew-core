class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.6/libclc-18.1.6.src.tar.xz"
  sha256 "adb73f49798cc271216ca7368da6991d5562efe7cffe2ad42d411bfa4a5c66dc"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a060da48543f4416eef21ad27b8836df85b2a7b5327d569b3a9a8ae9f966d99c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a060da48543f4416eef21ad27b8836df85b2a7b5327d569b3a9a8ae9f966d99c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a060da48543f4416eef21ad27b8836df85b2a7b5327d569b3a9a8ae9f966d99c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a060da48543f4416eef21ad27b8836df85b2a7b5327d569b3a9a8ae9f966d99c"
    sha256 cellar: :any_skip_relocation, ventura:        "a060da48543f4416eef21ad27b8836df85b2a7b5327d569b3a9a8ae9f966d99c"
    sha256 cellar: :any_skip_relocation, monterey:       "a060da48543f4416eef21ad27b8836df85b2a7b5327d569b3a9a8ae9f966d99c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e35771c125a35a4529d53511d9522165855862ef044d599b776fdfa644430f3a"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", ".", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    clang_args = %W[
      -target nvptx--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    (testpath/"add_sat.cl").write <<~EOS
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    EOS

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    assert_match "@llvm.sadd.sat.i8", shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
  end
end
