class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3014",
      revision: "852aafb163d32d5bad63c10bc323a02c28fec59d"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03d2308b17f9b942b83e071819ab98a167de14f071e33110510214881aa012fc"
    sha256 cellar: :any,                 arm64_ventura:  "2837df7a5eb64f8e63c63ab936c9770080108c432817dfe3f754bc1088d07f76"
    sha256 cellar: :any,                 arm64_monterey: "c004d3219e85df459afcc6dc9d1e7c0a7fdf3e98476697bbab5c47ffa96fd44a"
    sha256 cellar: :any,                 sonoma:         "bfef266af26104c280e25df7b4aa97ba749e32c7d542e2e067d0b22179eec18a"
    sha256 cellar: :any,                 ventura:        "85316a2fd38d4ce7dab97ac65f0ff56a66ce06010612926b6d16532aaa6a43ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76173968bf7db41d614f6d56ceccf9f34eedd442acb7af35eabb2f45baf535e4"
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
                        "-m", "stories15M-q4_0.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end
