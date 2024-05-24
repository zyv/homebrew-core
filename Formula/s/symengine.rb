class Symengine < Formula
  desc "Fast symbolic manipulation library written in C++"
  homepage "https://www.sympy.org/en/index.html"
  url "https://github.com/symengine/symengine/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "1b5c3b0bc6a9f187635f93585649f24a18e9c7f2167cebcd885edeaaf211d956"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0ec354593497defa98b87c5c01f019e496c5434ca7be1cf0ccfad7aa3d353908"
    sha256 cellar: :any,                 arm64_ventura:  "df36bbe8ff66b72650d28b7cd821f7859c666ccbcd7d8d5148012ed73bb44414"
    sha256 cellar: :any,                 arm64_monterey: "30e10dc0a06e53f43fe3b02e7c988b997f66f7311f7c2ab8bdbc8d6df9fffeeb"
    sha256 cellar: :any,                 sonoma:         "d1142560a962fbd72bd6f3f78b34ef6cd6ba84b1abc9cf5abfa1bb7495051a2c"
    sha256 cellar: :any,                 ventura:        "08366ea97ec72c41f3ee3dc1cc8cbdf13453c4435a1dca76d0d68266c00c108d"
    sha256 cellar: :any,                 monterey:       "c551b89cec835f3f779e423e9e24771b062517b3f12a398f0f7671576874761f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1fd34da0b75f0bc3b416590152e333a3dcc041adc31c0cc0dac6eeaf2519db6"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "llvm"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "z3"
  end

  fails_with gcc: "5"

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DWITH_GMP=ON",
                    "-DWITH_MPFR=ON",
                    "-DWITH_MPC=ON",
                    "-DINTEGER_CLASS=flint",
                    "-DWITH_LLVM=ON",
                    "-DWITH_COTIRE=OFF",
                    "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm",
                    "-DWITH_SYMENGINE_THREAD_SAFE=ON",
                    "-DWITH_SYSTEM_CEREAL=ON",
                    *std_cmake_args

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <symengine/expression.h>
      using SymEngine::Expression;
      int main() {
        auto x=Expression('x');
        auto ex = x+sqrt(Expression(2))+1;
        auto equality = eq(ex+1, expand(ex));
        return equality == true;
      }
    EOS
    lib_flags = [
      "-L#{Formula["gmp"].opt_lib}", "-lgmp",
      "-L#{Formula["mpfr"].opt_lib}", "-lmpfr",
      "-L#{Formula["flint"].opt_lib}", "-lflint"
    ]
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lsymengine", *lib_flags, "-o", "test"

    system "./test"
  end
end
