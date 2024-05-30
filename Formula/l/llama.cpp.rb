class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3040",
      revision: "55d62262a99cd8bc28a1492975791fe433c8cc0f"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aa04b4919f24ce3138f24b58529e642e183d4a2af37e96fdf419b298010fc8d1"
    sha256 cellar: :any,                 arm64_ventura:  "71b84c7df5e94317ac763994a2a5ca96a1b2878015f6b0da39e940d11ca4b5b4"
    sha256 cellar: :any,                 arm64_monterey: "149ee4b57051d25b8ba1d210b9a1d089adb86163176c5fa33c5113dff00022a5"
    sha256 cellar: :any,                 sonoma:         "6e9d5c092c9919a115a5541019ae4792a836887a3cd5cd44c88e83f6918dd3e9"
    sha256 cellar: :any,                 ventura:        "7d1d6c784de8aeee58dae74d6b0b0095b4c978896bef9e8e0499729db06ea8b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d03c0fcef22cdeb097bdea38b9dba2826010113143a4c9d59eddd8bca5090a"
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
