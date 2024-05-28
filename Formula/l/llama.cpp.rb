class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3023",
      revision: "ee3dff6b8e39bb8c1cdea1782a7b95ef0118f970"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5f19ecd79ddb48659b50e97b652654d47fd44c2d71167c77e226209a3db2ce27"
    sha256 cellar: :any,                 arm64_ventura:  "a66e69de08bcd56e85717079327b38a3f5fb2867cac99a83df8afee9158564fe"
    sha256 cellar: :any,                 arm64_monterey: "753dc74594de841972859376f7f1847f82e87904a6096081581670bb63b633d2"
    sha256 cellar: :any,                 sonoma:         "885676a7a9aa02ad9d8ebf30d3c6d2041823bda42425f74a3c8e6ab53907ed96"
    sha256 cellar: :any,                 ventura:        "f33671fb5629e21517616f860440fa8d4152767e4c4b778c8fb159c665df2571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad037fb97e2d36ef53a43af1c8ee2d02180acc09a63ccf0c1f6f39979d3faac0"
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
