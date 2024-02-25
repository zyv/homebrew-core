class Volk < Formula
  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v3.1.2/volk-3.1.2.tar.gz"
  sha256 "eded90e8a3958ee39376f17c1f9f8d4d6ad73d960b3dd98cee3f7ff9db529205"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "904c77dfba7c2aeca3ba875363ebbba857859df0072ba6b32289e141ca7e5a8a"
    sha256 arm64_ventura:  "4c4c45619caecaa3419bf98a1c68a3bb70a85dcaf4d9cc57e4b0ae46523b7b24"
    sha256 arm64_monterey: "9c111167ea8f07281e61740a4651063006a505ac7c497d30a19432412242ba15"
    sha256 sonoma:         "eaf827dc0425fb7dc6a756cdbb9cc0c30d8a8c0daf6cb42097bd31dfc40c537b"
    sha256 ventura:        "27de3aaa800c3a56987fa6bacea37a56adfaa1795da6687107ff547eaae944cd"
    sha256 monterey:       "c77d0d31077097db337b02b7a1713c618f8e683c946f4ad50245b7d25b10ce7c"
    sha256 x86_64_linux:   "a4ba5128a09670bd093bd169df91284e87e232583225e8a907de9ed16c96c674"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "pygments"
  depends_on "python-mako"
  depends_on "python-markupsafe"
  depends_on "python@3.12"

  on_intel do
    depends_on "cpu_features"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  # see discussions in https://github.com/gnuradio/volk/issues/745
  patch do
    url "https://github.com/gnuradio/volk/commit/bc59cad9dcde3865f87b71988634109bd3b6fb1c.patch?full_index=1"
    sha256 "52476d6ee7511ead8ee396f9f1af45bcd7519a859b088418232226c770a9864a"
  end

  def install
    python = "python3.12"

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    # cpu_features fails to build on ARM macOS.
    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python)}
      -DENABLE_TESTING=OFF
      -DVOLK_CPU_FEATURES=#{Hardware::CPU.intel?}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/volk_modtool", "--help"
    system "#{bin}/volk_profile", "--iter", "10"
  end
end
