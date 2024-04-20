class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ziglang.org/download/0.12.0/zig-0.12.0.tar.xz"
  sha256 "a6744ef84b6716f976dad923075b2f54dc4f785f200ae6c8ea07997bd9d9bd9a"
  license "MIT"

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "799a1caa052368deb7947441ffe504d8db28fa7b40a8a579d5f2f127fab8216f"
    sha256 cellar: :any,                 arm64_ventura:  "6f6299f3f2c1f62dd1111678a58ad9f9abd790f14c1d02959da823f00d616183"
    sha256 cellar: :any,                 arm64_monterey: "cf459782bb991b79c8f30424d63f7d7352d8659756c53c3c0881c7fd20f83198"
    sha256 cellar: :any,                 sonoma:         "3cd6b970924d7cae4ef2ceb73a3e8572d63ccc96bc8ae8d4b1b6144adcfd9781"
    sha256 cellar: :any,                 ventura:        "b2ee0ec4088368929a0f36bf40e11a0f5194373abc2c7b763b4f5a75ac9f59cf"
    sha256 cellar: :any,                 monterey:       "77d35330e2f4699df927993d1d65be6cc3e5d8d89149da1246c14909cca1e2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88b639b67b1112dff3e10e3e34057ea946d5e72ed246ca74a526d0aeaf786040"
  end

  depends_on "cmake" => :build
  # Check: https://github.com/ziglang/zig/blob/#{version}/CMakeLists.txt
  # for supported LLVM version.
  depends_on "llvm@17" => :build
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
  depends_on "z3"
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # `brew`'s compiler selector does not currently support using Clang from a
    # versioned LLVM so we need to manually bypass the shims.
    llvm = Formula["llvm@17"]
    ENV.prepend_path "PATH", llvm.opt_bin
    ENV["CC"] = llvm.opt_bin/"clang"
    ENV["CXX"] = llvm.opt_bin/"clang++"

    # build patch for libunwind linkage issue
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib

    # Work around failure with older Xcode's libc++:
    # Undefined symbols for architecture x86_64:
    # "std::__1::__libcpp_verbose_abort(char const*, ...)", referenced from:
    #     std::__1::__throw_out_of_range[abi:un170006](char const*) in libzigcpp.a(zig_clang_driver.cpp.o)
    ENV.append "LDFLAGS", "-L#{llvm.opt_lib}/c++" if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081.
    # This will likely be fixed upstream by https://github.com/ziglang/zig/pull/16062.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = ["-DZIG_STATIC_LLVM=ON"]
    args << "-DZIG_TARGET_MCPU=#{cpu}" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end
