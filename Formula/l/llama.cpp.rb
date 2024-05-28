class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3019",
      revision: "e2b065071c5fc8ac5697d12ca343551faee465cc"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e28142dbd531289b26faafb2fa701dd34b0ce0716f2f1265e6ed6249c5e7071d"
    sha256 cellar: :any,                 arm64_ventura:  "649854374d491bf3176c9ad09cfa5002a3e45cbdfa8ca58ce5bb3cf2257cf91f"
    sha256 cellar: :any,                 arm64_monterey: "e7a380880f9b2607c382c3c5407d3990a6eb0b2974d9d6d3c237953031ef5ab1"
    sha256 cellar: :any,                 sonoma:         "428edce14ef5797ccda12aa0c5afd4848a12a2ea250ef69f752ad303aca2d6bf"
    sha256 cellar: :any,                 ventura:        "f9645a36c38a14dc46b2eb51add715e34cc68c15fcbd59a25ff4509fe6d28874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf2015c0a809c65a6d27bcaf5002aa29742929c62675cb9c6d4c93f42afa6e5a"
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
