class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3046",
      revision: "9c4c9cc83f7297a10bb3b2af54a22ac154fd5b20"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ec5fcbb12496a4f2827e8ca10f849f74397287fcc8a00f9450d525e2cafc8267"
    sha256 cellar: :any,                 arm64_ventura:  "4ec7e38ef60b98c1a964405572e11a9256bf5326f4c4fe5df9767f5c0d5f5939"
    sha256 cellar: :any,                 arm64_monterey: "37ee6186e4029b087c8bbc3392fc45efb513c648362afceb54efd63359b3536b"
    sha256 cellar: :any,                 sonoma:         "87cb5e1d588ab955080c8c20b116642a56dab08df152b2008267989ba68295e1"
    sha256 cellar: :any,                 ventura:        "1fd3e7abde10a6a229a91517aa0ba8c275ea9a347f43fc596bf15e9dd2c99ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ce5b5ade4c906da2858dfcd8f16856dfc79b87844ded689c9a03c54681be16"
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
