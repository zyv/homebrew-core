class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3036",
      revision: "210d99173dc82aafb48f6e39d787c387951fe3a9"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eda1b922004e8edf25b6a8c0cf76eaf6811a07027e68f204f76a269b0205cb96"
    sha256 cellar: :any,                 arm64_ventura:  "41b771c78459a432ceec012a7ab5762c2ece38742cde0c2cfbd4c8229cbe15f7"
    sha256 cellar: :any,                 arm64_monterey: "4f1e9e26c2e99933b2e8cf6e3bedf1f5a88d35f41a73b1b5bf6745edb160685f"
    sha256 cellar: :any,                 sonoma:         "a33711b52839edb50f4fd2021ac88eb6fed12c966cb7f9eddd55038ad2cd63fc"
    sha256 cellar: :any,                 ventura:        "c5d50e236c424b910d55364dd98d7abb1f9bf2e78db7a1f1e785b2f6f9ba43df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0b786dae5bf76ce1f56d7b6c0e02a82137c84986121cf129a3d99014da4ba91"
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
