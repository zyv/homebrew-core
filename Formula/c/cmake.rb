class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.29.2/cmake-3.29.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.29.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.29.2.tar.gz"
  sha256 "36db4b6926aab741ba6e4b2ea2d99c9193222132308b4dc824d4123cb730352e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8d5c71bce53c78741564dce4fec1292039cd5a19d13ffba16c352c9a9f0ef28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df8417a1066147c7a728602b86fbd746b87ddaf1995d2c3c15706c8f7e1ce14e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d385e28294244b9df95178e020fb3e8d2633d95175ec4fafece2c0f63275644d"
    sha256 cellar: :any_skip_relocation, sonoma:         "447617ae169adea3b9092e466cdb383df7e6dac0beef66036a44f0989b37d400"
    sha256 cellar: :any_skip_relocation, ventura:        "8524a278943b3a44b11e70cf82facb11d32f32483627de2dac94cebeb4f00748"
    sha256 cellar: :any_skip_relocation, monterey:       "07166530d9015f13113bbe8da953f011e18df414914d87e7a7299f8b2f0a88de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1723aa66a1ad9cc8c6d711ccc90c6efcf7cd7a09d4ca2f9bc03f96619550b422"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
