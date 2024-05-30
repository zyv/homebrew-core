# TODO: Add this to Homebrew so it can be used as a dependency:
#       https://github.com/martinmoene/span-lite
class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.10/ccache-4.10.tar.xz"
  sha256 "83630b5e922b998ab2538823e0cad962c0f956fad1fcf443dd5288269a069660"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0c8879d73832689eab3f9048d0d83f5d32e6e05c97a414be28b323c5854571b0"
    sha256 cellar: :any,                 arm64_ventura:  "a94a223954ac1456ab20063bbfcb9bf63b3f1f87cb6608cc172a2ac78346d1a6"
    sha256 cellar: :any,                 arm64_monterey: "c4db07a5b0729a6ad510b34bf37189dfcd30038d7e941112abf19c4d37077546"
    sha256 cellar: :any,                 sonoma:         "631c5cbacaafa32442cd9c81872471bedbb14f4232bb07699dd86c72faaa853c"
    sha256 cellar: :any,                 ventura:        "2e0ad90b7dbf96d04e0bf45326f709068e875f522720c0b894fed421adb12372"
    sha256 cellar: :any,                 monterey:       "c6180bbf38804a67a412889b592673119756797c2ae6624862609230e9cbf57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f728a2c247c76cf136a809cbde7cf1c4a5c2c3f7e5b852085999f02aad79794b"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "cpp-httplib" => :build
  depends_on "doctest" => :build
  depends_on "pkg-config" => :build
  depends_on "tl-expected" => :build
  depends_on "blake3"
  depends_on "fmt"
  depends_on "hiredis"
  depends_on "xxhash"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_IPO=TRUE",
                    "-DREDIS_STORAGE_BACKEND=ON",
                    "-DDEPS=LOCAL",
                    *std_cmake_args
    system "cmake", "--build", "build"

    # Homebrew compiler shim actively prevents ccache usage (see caveats), which will break the test suite.
    # We run the test suite for ccache because it provides a more in-depth functional test of the software
    # (especially with IPO enabled), adds negligible time to the build process, and we don't actually test
    # this formula properly in the test block since doing so would be too complicated.
    # See https://github.com/Homebrew/homebrew-core/pull/83900#issuecomment-90624064
    with_env(CC: DevelopmentTools.locate(DevelopmentTools.default_compiler)) do
      system "ctest", "-j#{ENV.make_jobs}", "--test-dir", "build"
    end

    system "cmake", "--install", "build"

    libexec.mkpath

    %w[
      clang
      clang++
      cc
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0
      gcc-4.2 gcc-4.3 gcc-4.4 gcc-4.5 gcc-4.6 gcc-4.7 gcc-4.8 gcc-4.9
      gcc-5 gcc-6 gcc-7 gcc-8 gcc-9 gcc-10 gcc-11 gcc-12 gcc-13 gcc-14
      c++ c++3 c++-3.3 c++-4.0
      c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9
      c++-5 c++-6 c++-7 c++-8 c++-9 c++-10 c++-11 c++-12 c++-13 c++-14
      g++ g++2 g++3 g++-3.3 g++-4.0
      g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9
      g++-5 g++-6 g++-7 g++-8 g++-9 g++-10 g++-11 g++-12 g++-13 g++-14
      i686-w64-mingw32-gcc i686-w64-mingw32-g++
      x86_64-w64-mingw32-gcc x86_64-w64-mingw32-g++
    ].each do |prog|
      libexec.install_symlink bin/"ccache" => prog
    end
  end

  def caveats
    <<~EOS
      To install symlinks for compilers that will automatically use
      ccache, prepend this directory to your PATH:
        #{opt_libexec}

      If this is an upgrade and you have previously added the symlinks to
      your PATH, you may need to modify it to the path specified above so
      it points to the current version.

      NOTE: ccache can prevent some software from compiling.
      ALSO NOTE: The brew command, by design, will never use ccache.
    EOS
  end

  test do
    ENV.prepend_path "PATH", opt_libexec
    assert_equal "#{opt_libexec}/gcc", shell_output("which gcc").chomp
    system "#{bin}/ccache", "-s"
  end
end
