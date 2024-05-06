class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.11.5.tar.gz"
  sha256 "83b7699d0aee3aa1683721fe4b82d667c88e97e257d48e9efe586b0e830f8a64"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "bbd9a64d0fa1ea0225980d00672deaf8e7475209adf5f90ff548bc07c47a2acb"
    sha256 arm64_ventura:  "9535aabc847cf608db8b8212d07a1cec6c5325a14daf7a576986e82432e3ccac"
    sha256 arm64_monterey: "49590e8909203157a746d9734b101559c2e1d90d4e4c38c39cd36859313cf5bb"
    sha256 sonoma:         "2706a4fa940d11ad9fed857bfb7da92508f2a9bffd3cfa9031da558e468eb346"
    sha256 ventura:        "7feac33da15e7e56dc4de0e3d9921b3f43aeb4d62c729977c85e2e6db35d0a31"
    sha256 monterey:       "70494732db3b8354c81bba5bfe3596372102004383adaee5ea03d9d97cbe381f"
    sha256 x86_64_linux:   "9f8870e750d86684b9301f5fcae4a4633e4e137c0faa7a81a04d11101edcf760"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pciutils" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
