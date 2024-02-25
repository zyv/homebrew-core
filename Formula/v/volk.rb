class Volk < Formula
  include Language::Python::Virtualenv

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
  depends_on "cpu_features"
  depends_on "orc"
  depends_on "python@3.12"

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  resource "mako" do
    url "https://files.pythonhosted.org/packages/d4/1b/71434d9fa9be1ac1bc6fb5f54b9d41233be2969f16be759766208f49f072/Mako-1.3.2.tar.gz"
    sha256 "2a0c8ad7f6274271b3bb7467dd37cf9cc6dab4bc19cb69a4ef10669402de698e"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  def install
    python3 = "python3.12"

    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/Language::Python.site_packages(python3)

    # Avoid falling back to bundled cpu_features
    (buildpath/"cpu_features").rmtree

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DENABLE_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/volk_modtool", "--help"
    system "#{bin}/volk_profile", "--iter", "10"
  end
end
