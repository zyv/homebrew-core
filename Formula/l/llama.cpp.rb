class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3003",
      revision: "d298382ad977ec89c8de7b57459b9d7965d2c272"
  version "b3003"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

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
