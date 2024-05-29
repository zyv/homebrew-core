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
    sha256 cellar: :any,                 arm64_sonoma:   "cf88790ea86f789183f093356463b8e91302bbc42c3073837e56a4845a7cd619"
    sha256 cellar: :any,                 arm64_ventura:  "2ab12c2b1f6bc2a1bee94b5abeef5367c55eb5c8432cd7770a34ebcedee55291"
    sha256 cellar: :any,                 arm64_monterey: "8578c0526e5665a4960758be69f6d9cd9aa9fd21e03fb12b69580fcf247046ee"
    sha256 cellar: :any,                 sonoma:         "ca5e341db6891a846265fecfdde11b3b0ed5ab8cc8e7fb51d48f54f5fb9475b3"
    sha256 cellar: :any,                 ventura:        "8dc07d2c78795f5d0519eb5a48c8bb32f8b1ca539daed9cdb38dc52ec0830790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c077fe9bd03538b2e876a2578231bda535f172148abe1c74d31fe309b733cc65"
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
