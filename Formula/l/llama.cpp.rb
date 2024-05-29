class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3030",
      revision: "504f0c340f6b5e04de682f6ddefdd3b81208df5d"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9ec679eb1556c141d969d6e8eb87f8645a5b12a645d1fa6d1adb24d9148243be"
    sha256 cellar: :any,                 arm64_ventura:  "646f531ef4dd9efb289b995217748b6d2b55ae39854634da3eb84b34afd1adf3"
    sha256 cellar: :any,                 arm64_monterey: "9c96081a727634fe77a0ba332993af8eb8f23a8a1a422e316492e9af2cd8ea60"
    sha256 cellar: :any,                 sonoma:         "85b8f903d64c5320c4cdd83584b5e8eb4396fed3b067031d4442fff7c7a9a247"
    sha256 cellar: :any,                 ventura:        "a059eeb4c9a047bcc1d8bb881ab70d2eb9f1cf77f1c3f54cb7042fe5d0803c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee35333a02e7f2d2feb4494c9a51c486d2c5cbc5898edbd51598eb71dd77bd6e"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin/"llama", "--hf-repo", "ggml-org/tiny-llamas",
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end
